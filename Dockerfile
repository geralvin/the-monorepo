FROM node:14-alpine AS builder
ARG APP

WORKDIR /app
RUN apk add --no-cache libc6-compat
COPY . .
RUN yarn install
RUN yarn build --filter=${APP}

# RUNNER
FROM node:14-alpine AS runner
ARG APP

WORKDIR /app

RUN addgroup -g 1001 -S nodejs
RUN adduser -S runner -u 1001

COPY --from=builder --chown=runner:nodejs /app ./
RUN echo -n ${APP} >> manifest

USER runner

EXPOSE 3000

ENV PORT 3000
CMD ["sh", "-c", "yarn run start --filter=$(cat manifest)"]
