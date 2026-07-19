---
message: "\\connect: %s"
slug: connect
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:4286"
reproduced: false
---

# `\connect: %s`

## What it means

psql's `\connect` meta-command failed. The message carries the underlying reason (for example an authentication or network failure) after the colon. The previous connection is retained when a reconnect fails.

## When it happens

It happens in psql when `\connect` (or `\c`) cannot establish the requested connection, due to bad credentials, an unreachable host, or a nonexistent database.

## How to fix

Read the reason after `\connect:` and address it — check the target database name, host, port, user, and password. Correct the connection parameters and try `\c` again.

## Example

*Illustrative* — a failed reconnect in psql.

```text
\connect: connection to server ... failed: ...
```

## Related

- [connection to server was lost](./connection-to-server-was-lost.md)
- [connection to database failed](./connection-to-database-failed-ed5fa7.md)
