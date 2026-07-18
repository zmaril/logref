---
message: "there is no transaction in progress"
slug: there-is-no-transaction-in-progress
passthrough: false
api: [ereport]
level: [WARNING]
sqlstate:
  - symbol: ERRCODE_NO_ACTIVE_SQL_TRANSACTION
    code: "25P01"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:4127"
  - "postgres/src/backend/access/transam/xact.c:4206"
  - "postgres/src/backend/access/transam/xact.c:4329"
reproduced: true
---

# `there is no transaction in progress`

## What it means

A transaction-control command ran with no open transaction to act on. `COMMIT`, `ROLLBACK`, and friends only make sense inside an explicit transaction block; issued on their own they have nothing to finish. This is a `WARNING`, not an error — the statement is a harmless no-op and the session continues.

## When it happens

A `COMMIT` or `ROLLBACK` sent when the session is in autocommit mode with no `BEGIN`, or a second `COMMIT` after the block already ended, or transaction control that got out of sync with the application's own bookkeeping.

## Is this a problem?

Because it is only a warning, no action is strictly required — the command did nothing. If the warnings are noise, audit the code that emits `COMMIT`/`ROLLBACK` and make sure each is paired with a matching `BEGIN`. Many drivers manage transactions for you, so an extra explicit `COMMIT` on top of the driver's own can produce these. Match every commit to an open block.

## Example

*Reproduced* — The transaction/session reproducer scenario commits with no open block (`14_txn_session.sql`).

```sql
COMMIT;
```

Produces:

```text
WARNING:  there is no transaction in progress
```

## Related

- [cursor does not exist](./cursor-does-not-exist.md)
