# Stage 1: Build
FROM node:18-alpine as build

WORKDIR /app

COPY package.json yarn.lock* package-lock.json* ./
RUN yarn install || npm install

COPY . .

RUN yarn build || npm run build

# Stage 2: Serve
FROM node:18-alpine

WORKDIR /app

COPY --from=build /app ./

EXPOSE 3000

CMD ["npm", "start"]
