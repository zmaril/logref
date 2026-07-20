---
message: "cannot change ownership of identity sequence"
slug: cannot-change-ownership-of-identity-sequence
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/sequence.c:1673"
reproduced: false
---

# `cannot change ownership of identity sequence`

## What it means

A command tried to change the ownership link of a sequence that backs an identity column. Identity sequences are bound to their column and managed automatically, so their ownership cannot be reassigned independently.

## When it happens

It occurs when running `ALTER SEQUENCE ... OWNED BY` or a related command against a sequence generated for a `GENERATED ... AS IDENTITY` column.

## How to fix

Leave identity sequences managed by their column. If you need a freely owned sequence, use an explicitly created sequence with a `DEFAULT` rather than an identity column.

## Example

*Illustrative* — reassigning an identity sequence.

```text
ERROR:  cannot change ownership of identity sequence
```

## Related

- [cannot change owner of sequence](./cannot-change-owner-of-sequence.md)
- [cannot change identity column of a partition](./cannot-change-identity-column-of-a-partition.md)
