FROM ghcr.io/gohugoio/hugo:latest AS build

ARG ENVIRONMENT

ENV ENVIRONMENT=${ENVIRONMENT:-main}

ADD --chown=hugo:hugo . . 

RUN hugo --minify --environment $ENVIRONMENT

FROM nginx:1-alpine

LABEL org.opencontainers.image.source="https://github.com/Coto-Studio/hugo-inbar.git"

ADD default.conf /etc/nginx/conf.d/

COPY --from=build /project/public /usr/share/nginx/html

EXPOSE 80