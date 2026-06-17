FROM node:22.13.0-bookworm-slim AS deps

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

FROM deps AS bundle

ARG PLATFORM=all
ENV NODE_ENV=production

WORKDIR /app
COPY . .

RUN case "$PLATFORM" in \
      android) npm run bundle:android ;; \
      ios) npm run bundle:ios ;; \
      all|android,ios|ios,android) npm run bundle:android && npm run bundle:ios ;; \
      *) echo "Unsupported PLATFORM: $PLATFORM. Use android, ios, all, android,ios, or ios,android." && exit 1 ;; \
    esac

FROM scratch AS bundle-output

COPY --from=bundle /app/dist/ /
