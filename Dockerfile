FROM node:12

LABEL maintainer=<dbcluster@gmail.com>

WORKDIR /api/

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 4000
CMD [ "npm", "start" ]