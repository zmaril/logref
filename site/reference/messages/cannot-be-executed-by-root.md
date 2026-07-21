---
message: "cannot be executed by \"root\""
slug: cannot-be-executed-by-root
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2321"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:390"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:283"
reproduced: false
---

# `cannot be executed by "root"`

## What it means

A Postgres server-side program refused to run as the operating-system superuser (`root`). The server and its tools drop this privilege deliberately: running as root would let any security hole in the database compromise the whole host, so they refuse to start under that account.

## When it happens

Launching `postgres`, `initdb`, or a related backend tool while logged in as (or executing under) the `root` account rather than a dedicated unprivileged database user.

## How to fix

Run the program as a non-root account — the conventional `postgres` OS user. Switch with `su - postgres` (or `sudo -u postgres ...`) before invoking the tool, and make sure the data directory is owned by that user. Client programs like `psql` are not affected; this restriction is for the server-side binaries.

## Example

*Illustrative* — starting the server as root.

```sh
# as root:
postgres -D /data   # error: cannot be executed by "root"
su - postgres -c 'postgres -D /data'
```

## Related

- [could not determine current directory](./could-not-determine-current-directory.md)
- [no data directory specified](./no-data-directory-specified.md)
