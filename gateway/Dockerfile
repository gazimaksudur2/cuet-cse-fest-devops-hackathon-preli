# gateway/Dockerfile
FROM node:20-alpine

WORKDIR /app
ENV NODE_ENV=production

COPY package*.json ./
RUN npm ci --omit=dev

COPY src ./src

# Gateway listens on GATEWAY_PORT (5921)
EXPOSE 5921

CMD ["npm", "run", "start"]
