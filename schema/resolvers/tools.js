import { UserInputError, ApolloError } from 'apollo-server';
import pubsub, { EVENTS } from '../../subscription';
import mongoDao from '../../@lib/mongodao';
import { mkdir } from 'fs';
import { searchPipeline, categoryPipeline } from '../../util/tools/pipeline';

const { ObjectID } = require('mongodb');
const { validateToolInput } = require('../../util/validators');
const database = process.env.MONGODB_DB;
const toCursorHash = (string) => Buffer.from(string).toString('base64');
const fromCursorHash = (string) => {
  console.log(string, 'test string');
  return Buffer.from(string, 'base64').toString('ascii');
};

const toolsResolver = {
  ToolResult: {
    __resolveType(obj, context, info) {
      if (obj.title) {
        return 'Tool';
      }

      if (obj.message) {
        return 'ToolNotFound';
      }

      return null;
    },
  },
  Query: {
    getTools: async (_, { cursor, limit = 9 }) => {
      const cursorOptions = cursor ? { createdAt: { $lt: fromCursorHash(cursor) } } : {};
      const allTools = await mongoDao.getAllDocs(database, 'tools', cursorOptions, limit);
      const hasNextPage = allTools.length > limit;
      const edges = hasNextPage ? allTools.slice(0, -1) : allTools;
      return {
        edges,
        pageInfo: {
          hasNextPage,
          endCursor: toCursorHash(edges[edges.length - 1].createdAt.toString()),
        },
      };
    },
    getToolsByCategory: async (_, { cursor, limit = 9, category }) => {
      const cursorOptions = cursor
        ? [
            {
              createdAt: {
                $lt: fromCursorHash(cursor),
              },
            },
          ]
        : {};

      let pipeline, tools;
      try {
        pipeline = categoryPipeline(category, limit);
        tools = await mongoDao.pool.db(database).collection('tools').aggregate(pipeline, cursorOptions).toArray();

        const hasNextPage = tools.length > limit;
        const edges = hasNextPage ? tools.slice(0, -1) : tools;
        return {
          edges,
          pageInfo: {
            hasNextPage,
            endCursor: toCursorHash(edges[edges.length - 1].createdAt.toString()),
          },
        };
      } catch (error) {
        throw new ApolloError(`Unable to get tools by category, reason: ${error.message}`);
      }
    },
    getToolById: async (_, { toolId }) => {
      let tool;
      try {
        tool = await mongoDao.getOneDoc(database, 'tools', '_id', ObjectID(toolId));
      } catch (error) {
        tool = {};
        throw new ApolloError(`The tool with the id ${toolId} cannot be located, reason: ${error.message}`);
      }
      return tool;
    },
    searchTools: async (_, { search }) => {
      const where = {};

      if (search) {
        where.search = search;
      }

      let pipeline, tools;

      try {
        pipeline = searchPipeline(where);
        tools = await mongoDao.pool.db(database).collection('tools').aggregate(pipeline).toArray();
      } catch (error) {
        tools = {};
        throw new ApolloError(`Unable to search tools, reason: ${error.message}`);
      }
      return tools;
    },
  },
  Mutation: {
    addTool: async (_, { input, location, file }, { me }) => {
      const dbTools = await mongoDao.pool.db(database).collection('tools');

      if (!me) {
        throw new Error('only an authorized user can post a tool');
      }

      try {
        const { errors, valid } = validateToolInput(input.title, input.make, input.model, input.description);

        if (!valid) {
          throw new UserInputError('Errors', { errors });
        }

        mkdir('assets/img', { recursive: true }, (err) => {
          if (err) throw err;
        });

        const upload = await mongoDao.processUpload(file);

        const newTool = {
          ...input,
          location: {
            ...location,
          },
          photo: upload,
          userId: ObjectID(me._id),
          createdAt: new Date(),
          updatedAt: new Date(),
        };

        const { insertedId } = await dbTools.insertOne(newTool);
        newTool._id = insertedId;

        pubsub.publish(EVENTS.TOOL.ADDED, {
          toolAdded: { newTool },
        });

        return newTool;
      } catch (error) {
        throw error;
      }
    },
    updateTool: async (_, args) => {
      const result = await mongoDao.updateOneDoc(database, 'tools', '_id', args);

      if (result.matchedCount === 0) {
        console.error(`Delete failed! ${result.matchedCount} document(s) matched the query criteria`);
        console.log(`${result.modifiedCount} document(s) was/were updated`);
        return false;
      } else {
        console.log(`${result.matchedCount} document(s) matched the query criteria`);
        console.log(`${result.modifiedCount} document(s) was/were updated`);
        return true;
      }
    },
    deleteTool: async (_, args) => {
      const { deletedCount } = await mongoDao.pool
        .db(database)
        .collection('tools')
        .deleteOne({ _id: ObjectID(args._id) });

      if (deletedCount === 0) {
        console.error(`Delete failed with error: ${err}`);
        return false;
      } else {
        console.log(`Deleted ${deletedCount} document(s).`);
        return true;
      }
    },
  },
  Subscription: {
    toolAdded: {
      subscribe: () => pubsub.asyncIterator(EVENTS.TOOL.ADDED),
    },
  },
  Tool: {
    url: (parent) => `/${parent.photo.path || parent.photo.path.toString()}`,
    user: async (parent, _, { userLoader }) => {
      const user = await userLoader.load(parent.userId);
      return user;
    },
  },
};

export default toolsResolver;
