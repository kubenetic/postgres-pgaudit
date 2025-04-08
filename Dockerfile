FROM docker.io/library/postgres:16-bookworm

USER root

COPY config/postgresql.conf /etc/postgresql/postgresql.conf

RUN apt-get update -y \
    && apt-get install -y \
        postgresql-16-pgaudit \
        postgresql-16-pgauditlogtofile \
    && apt-get clean

USER postgres

ENV TZ=Europe/Budapest

COPY --chown=999:999 pgaudit/0001_create_pgaudit_extension.sql /docker-entrypoint-initdb.d/
COPY --chown=999:999 pgaudit/0002_create_pgaudit_role.sql      /docker-entrypoint-initdb.d/