FROM node:8.9.4

WORKDIR /app

COPY package*.json ./

RUN npm --force install
COPY . .
RUN npm --force run client-install

EXPOSE 5000
CMD npm run dev
