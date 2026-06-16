FROM node:22.13.0-bookworm-slim AS deps

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

FROM deps AS bundle

ARG PLATFORM=android
ENV NODE_ENV=production

WORKDIR /app
COPY . .

RUN npm run bundle:${PLATFORM}

FROM scratch AS bundle-output

COPY --from=bundle /app/dist/ /
