---
message: "connection to database failed: %s"
slug: connection-to-database-failed-ed5fa7
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:594"
reproduced: false
---

# `connection to database failed: %s`

## What it means

`pg_createsubscriber` (or a related tool) could not connect to a database it needs. The message includes the underlying libpq failure reason.

## When it happens

It happens when the tool's connection to the target or source database fails, due to wrong connection parameters, authentication problems, or the server being unreachable.

## How to fix

Read the reason in the message and fix the connection details — host, port, database, user, password, and `pg_hba.conf` rules. Verify the server is running and reachable, then rerun the tool.

## Example

*Illustrative* — a tool failing to connect.

```text
pg_createsubscriber: error: connection to database failed: ...
```

## Related

- [connection to server was lost](./connection-to-server-was-lost.md)
- [consider renaming this publication before continuing](./consider-renaming-this-publication-before-continuing.md)
