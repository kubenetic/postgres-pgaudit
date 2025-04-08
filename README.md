# PostgreSQL with pgAudit

This project was created because I needed a PostgreSQL server with audit capabilities. It's based on the
official `postgres:16-bookworm` Docker image from Docker Hub. During the build of this image, the 
`postgresql-16-pgaudit` and `postgresql-16-pgauditlogtofile` packages were installed. Three additional
files rpovide the configuration necessary to ensure audit extension works properly:

- *pgaudit/0001_create_pgaudit_extension.sql*: Creates the pgAudit extension.
- *pgaudit/0002_create_pgaudit_role.sql*: Creates the audit role and alters its permissions. Among
  others changes, it revokes the login permission.
- *config/postgresql.conf*: Contains configurations for the database. This can be freely modified and
  mounted into the container using a volume. It can be placed anywhere, but you must specify its path
  when starting the database.

As stated on the [base image's Docker Hub page](https://hub.docker.com/_/postgres) at a minimum, the
`POSTGRES_PASSWORD` environment variable must be specified. In addition, you must explicitly specify 
the path to the `postgresl.conf` file.

The logfiles saved under the path `/var/log/postgresql`

# Usage examples

## Use as-is

```bash
docker run --detach \
    --env POSTGRES_PASSWORD=1234 \
    kubenetic/auditedpg:16-bookworm -c 'config_file=/etc/postgresql/postgresql.conf'
```

## Use with custom config

```bash
docker run --detach \
  --env POSTGRES_PASSWORD=mysecretpassword \
  --volume $(pwd)/my_postgresql.conf:/etc/postgresql/postgresql.conf \
  kubenetic/auditedpg:16-bookworm -c 'config_file=/etc/postgresql/postgresql.conf'
```

## Expose logfiles with a volume

```bash
docker run --detach \
    --env POSTGRES_PASSWORD=1234 \
    --volume $(pwd)/logs/:/var/log/postgresql \
    kubenetic/auditedpg:16-bookworm -c 'config_file=/etc/postgresql/postgresql.conf'
```