---
message: "cannot PREPARE a transaction that has operated on temporary objects"
slug: cannot-prepare-a-transaction-that-has-operated-on-temporary-objects
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:2658"
reproduced: false
---

# `cannot PREPARE a transaction that has operated on temporary objects`

## What it means

A `PREPARE TRANSACTION` was rejected because the transaction used temporary objects. Temporary objects belong to the session and vanish at session end, so a prepared transaction another session might commit cannot own them.

## When it happens

It occurs when a transaction creates or writes temporary tables (or other temporary objects) and then issues `PREPARE TRANSACTION`.

## How to fix

Keep temporary-object work out of two-phase-commit transactions. Use permanent objects, or commit the transaction normally instead of preparing it.

## Example

*Illustrative* — PREPARE after using a temp table.

```text
ERROR:  cannot PREPARE a transaction that has operated on temporary objects
```

## Related

- [cannot PREPARE a transaction that has created a cursor WITH HOLD](./cannot-prepare-a-transaction-that-has-created-a-cursor-with-hold.md)
- [cannot PREPARE a transaction that modified relation mapping](./cannot-prepare-a-transaction-that-modified-relation-mapping.md)
