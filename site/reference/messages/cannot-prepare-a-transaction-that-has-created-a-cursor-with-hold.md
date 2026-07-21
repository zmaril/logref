---
message: "cannot PREPARE a transaction that has created a cursor WITH HOLD"
slug: cannot-prepare-a-transaction-that-has-created-a-cursor-with-hold
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/mmgr/portalmem.c:737"
reproduced: true
---

# `cannot PREPARE a transaction that has created a cursor WITH HOLD`

## What it means

A `PREPARE TRANSACTION` (two-phase commit) was rejected because the transaction created a `WITH HOLD` cursor. A held cursor keeps resources open past the transaction, which a prepared transaction cannot carry across its later commit or rollback.

## When it happens

It occurs when a session declares a `CURSOR ... WITH HOLD` and then runs `PREPARE TRANSACTION` to enter two-phase commit.

## How to fix

Close held cursors before preparing the transaction, or avoid `WITH HOLD` in transactions that use two-phase commit. Fetch what you need and `CLOSE` the cursor first.

## Example

*Reproduced* — captured from `reproducers/scenarios/51_twophase_prepare.sql`.

```sql
PREPARE TRANSACTION 'g_cursor';
```

Produces:

```text
ERROR:  cannot PREPARE a transaction that has created a cursor WITH HOLD
```

## Related

- [cannot PREPARE a transaction that has exported snapshots](./cannot-prepare-a-transaction-that-has-exported-snapshots.md)
- [cannot PREPARE a transaction that has operated on temporary objects](./cannot-prepare-a-transaction-that-has-operated-on-temporary-objects.md)
