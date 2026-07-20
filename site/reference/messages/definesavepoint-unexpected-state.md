---
message: "DefineSavepoint: unexpected state %s"
slug: definesavepoint-unexpected-state
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xact.c:4499"
reproduced: false
---

# `DefineSavepoint: unexpected state %s`

## What it means

An internal transaction-state guard. `DefineSavepoint` was called while the transaction machinery was in a state where a savepoint cannot be created. The placeholder names the state. This is a "can't happen" check.

## When it happens

It fires when `SAVEPOINT` (or an internal subtransaction) is attempted outside a valid in-progress transaction block, which usually reflects an internal logic error rather than ordinary SQL.

## How to fix

This is not a user-facing condition. Savepoints require an open transaction block; if you reached this through an extension or driver, review how it manages transaction state. Capture the log and server version, since a reproducible case is worth reporting to the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
FATAL:  DefineSavepoint: unexpected state INPROGRESS
```

## Related

- [cannot free an active snapshot](./cannot-free-an-active-snapshot.md)
- [DO statement returned a row](./do-statement-returned-a-row.md)
