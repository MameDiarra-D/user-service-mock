FROM node:20-alpine

WORKDIR /app

COPY package.json ./
RUN npm install --omit=dev

COPY user-service.yaml ./

EXPOSE 4010

CMD ["npx", "prism", "mock", "user-service.yaml", "-p", "4010", "-h", "0.0.0.0", "--cors", "-d"]
