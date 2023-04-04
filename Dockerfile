# syntax=docker/dockerfile:1
FROM starsiege/wine:latest
ENV TERM=dumb
ENV WINEPREFIX=/wineprefix
EXPOSE 29001
VOLUME ["/wineprefix"]
WORKDIR /app
COPY . /
RUN apk add --no-cache setpriv && chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]