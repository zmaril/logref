---
message: "cannot perform COPY FREEZE because the table was not created or truncated in the current subtransaction"
slug: cannot-perform-copy-freeze-because-the-table-was-not-created-or-truncated-in
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/copyfrom.c:906"
reproduced: false
---

# `cannot perform COPY FREEZE because the table was not created or truncated in the current subtransaction`

## What it means

A `COPY ... WITH (FREEZE)` was rejected because the table was not created or truncated in the current subtransaction. `FREEZE` is only safe when the loading transaction owns the table's storage exclusively, which requires creating or truncating it in the same (sub)transaction.

## When it happens

It occurs when you run `COPY FREEZE` on a pre-existing table without first creating or truncating it in the current transaction or savepoint.

## How to fix

Create or `TRUNCATE` the table within the same transaction (or subtransaction) before the `COPY FREEZE`. Wrap the truncate and the freeze-load together so the table's storage is exclusively yours.

## Example

*Illustrative* — COPY FREEZE on a pre-existing table.

```text
ERROR:  cannot perform COPY FREEZE because the table was not created or truncated in the current subtransaction
```

## Related

- [cannot perform COPY FREEZE because of prior transaction activity](./cannot-perform-copy-freeze-because-of-prior-transaction-activity.md)
- [cannot perform COPY FREEZE on a foreign table](./cannot-perform-copy-freeze-on-a-foreign-table.md)
