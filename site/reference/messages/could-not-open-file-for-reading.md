---
message: "could not open file \"%s\" for reading: %m"
slug: could-not-open-file-for-reading
passthrough: false
api: [ereport, pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/commands/copyfrom.c:1901"
  - "postgres/src/backend/commands/extension.c:4023"
  - "postgres/src/backend/utils/adt/genfile.c:121"
  - "postgres/src/backend/utils/time/snapmgr.c:1448"
  - "postgres/src/bin/initdb/initdb.c:699"
  - "postgres/src/bin/initdb/initdb.c:1715"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:420"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:610"
  - "postgres/src/bin/pg_rewind/file_ops.c:349"
  - "postgres/src/common/controldata_utils.c:92"
  - "postgres/src/common/controldata_utils.c:98"
reproduced: false
---

# `could not open file "%s" for reading: %m`

## What it means

Opening a file specifically for reading failed. The path is the first placeholder and `%m` the OS error. This is the read-oriented variant of the open failure, used where the code only needs to read (config, control data, `COPY FROM`, extension scripts).

## When it happens

`COPY FROM 'file'`, loading an extension's SQL script, reading the control file or a config include, or a client reading input. Common `%m`: `No such file or directory`, `Permission denied`. For server-side `COPY`, the file must be readable by the `postgres` OS user, not the client.

## How to fix

Read `%m`. `No such file or directory` — check the path (and remember server-side `COPY` paths are on the server host). `Permission denied` — the server's OS user must be able to read the file. For client-side reads, use `\copy` in `psql` so the file is read with your credentials. Confirm the path and ownership.

## Example

*Illustrative* — a server-side COPY from an unreadable file.

```sql
COPY t FROM '/root/secret.csv';
```

Produces:

```text
ERROR:  could not open file "/root/secret.csv" for reading: Permission denied
```

## Related

- [could not open file](./could-not-open-file-420e05.md)
- [could not read from file](./could-not-read-from-file.md)
