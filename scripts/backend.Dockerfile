FROM mysql:5.6

ENV MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
ENV MYSQL_DATABASE=${MYSQL_DATABASE}
ENV MYSQL_USER=${MYSQL_USER}

RUN addgroup --gid 1627 client \
    && adduser --uid 1627 --gid 1627 client 

COPY --chown=client:client ./db/babyname.sql /docker-entrypoint-initdb.d/db.sql
