---
message: "cannot alter multirange type %s"
slug: cannot-alter-multirange-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:3930"
reproduced: false
---

# `cannot alter multirange type %s`

## What it means

An `ALTER TYPE` command targeted a multirange type directly. The placeholder is the type name. A multirange type is created and maintained together with its range type, so it cannot be altered on its own.

## When it happens

It occurs when running `ALTER TYPE` against the automatically created multirange type rather than its underlying range type.

## How to fix

Alter the underlying range type instead; its multirange type follows. The multirange is a derived type and does not accept direct alterations.

## Example

*Illustrative* — altering a multirange type directly.

```sql
ALTER TYPE int4multirange RENAME TO m;
```

## Related

- [cache lookup failed for multirange type](./cache-lookup-failed-for-multirange-type.md)
- [cannot alter type because it is the type of a typed table](./cannot-alter-type-because-it-is-the-type-of-a-typed-table.md)
