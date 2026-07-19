---
message: "failed to commit transaction: %s"
slug: failed-to-commit-transaction
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/contrib/vacuumlo/vacuumlo.c:355"
  - "postgres/contrib/vacuumlo/vacuumlo.c:386"
reproduced: false
---

# `failed to commit transaction: %s`

## What it means

The `vacuumlo` utility could not commit a transaction against the server. The `%s` is the server error. Its work for that batch was not committed.

## When it happens

The connection failed or the server returned an error at commit while `vacuumlo` removed orphaned large objects.

## How to fix

Read the server error. Confirm the connection is stable and the role has the needed privileges, then rerun `vacuumlo`.

## Example

*Illustrative* — a commit failed in vacuumlo.

```text
vacuumlo: error: failed to commit transaction: server closed the connection unexpectedly
```

## Related

- [failed to start transaction](./failed-to-start-transaction.md)
- [error message from server](./error-message-from-server.md)
