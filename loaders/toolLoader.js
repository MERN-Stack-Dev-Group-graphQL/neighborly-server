import DataLoader from 'dataloader';
import mongoDao from '../@lib/mongodao';

const database = process.env.MONGODB_DB;
const collection = 'tools';
const field = '_id';

const batchTools = async (keys) => {
  const tools = await mongoDao.pool
    .db(database)
    .collection(collection)
    .find({
      [field]: {
        $in: keys,
      },
    })
    .toArray();

  return keys.map((key) => tools.find((tool) => tool.id == key));
};

export const toolLoader = () => new DataLoader(batchTools);
