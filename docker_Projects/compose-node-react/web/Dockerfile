FROM node:latest

RUN apt-get -y update && apt-get -y upgrade
RUN npm create -y vite@latest app -- --template react

WORKDIR /app

RUN npm install

CMD [ "npm", "run", "dev", "--", "--host" ]