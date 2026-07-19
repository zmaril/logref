---
message: "database connection requirement not indicated during registration"
slug: database-connection-requirement-not-indicated-during-registration
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/postmaster/bgworker.c:889"
  - "postgres/src/backend/postmaster/bgworker.c:923"
reproduced: false
---

# `database connection requirement not indicated during registration`

## What it means

A background worker tried to connect to a database, but it did not declare that it needed a database connection when it was registered. Workers must set the connect-to-database flag at registration to be allowed to connect.

## When it happens

An extension's worker calls `BackgroundWorkerInitializeConnection` without having set `BGWORKER_BACKEND_DATABASE_CONNECTION` in its registration flags. It is an extension coding issue.

## How to fix

This is a bug in the extension. Its worker registration must include the database-connection flag. Update the extension; report it to the authors with the worker name.

## Example

*Illustrative* — a worker connected without declaring the need.

```text
FATAL:  database connection requirement not indicated during registration
```

## Related

- [could not register background process](./could-not-register-background-process.md)
- [could not start background process](./could-not-start-background-process.md)
