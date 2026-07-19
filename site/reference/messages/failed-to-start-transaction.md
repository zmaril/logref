---
message: "failed to start transaction: %s"
slug: failed-to-start-transaction
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/contrib/vacuumlo/vacuumlo.c:277"
  - "postgres/contrib/vacuumlo/vacuumlo.c:366"
reproduced: false
---

# `failed to start transaction: %s`

## What it means

The `vacuumlo` utility could not begin a transaction on the server. The `%s` is the server error. It could not start the work unit for removing orphaned large objects.

## When it happens

The connection failed or the server returned an error when `vacuumlo` issued `BEGIN`.

## How to fix

Read the server error. Confirm the connection is stable and the role has the needed privileges, then rerun `vacuumlo`.

## Example

*Illustrative* — BEGIN failed in vacuumlo.

```text
vacuumlo: error: failed to start transaction: server closed the connection unexpectedly
```

## Related

- [failed to commit transaction](./failed-to-commit-transaction.md)
- [could not launch shell command](./could-not-launch-shell-command.md)
