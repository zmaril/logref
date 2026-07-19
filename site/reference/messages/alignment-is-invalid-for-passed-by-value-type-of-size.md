---
message: "alignment \"%c\" is invalid for passed-by-value type of size %d"
slug: alignment-is-invalid-for-passed-by-value-type-of-size
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/catalog/pg_type.c:267"
  - "postgres/src/backend/catalog/pg_type.c:275"
  - "postgres/src/backend/catalog/pg_type.c:283"
  - "postgres/src/backend/catalog/pg_type.c:291"
reproduced: false
---

# `alignment "%c" is invalid for passed-by-value type of size %d`

## What it means

A type definition specified an alignment that is inconsistent with a pass-by-value type of the given size. The placeholders are the alignment character and the size. Pass-by-value types must have an alignment matching their size (for example 4-byte types use `int` alignment, 8-byte types use `double`); a mismatch is rejected.

## When it happens

Running `CREATE TYPE` (a base type) with `PASSEDBYVALUE` and an `ALIGNMENT` that does not correspond to the `INTERNALLENGTH` — typically when defining a custom C type by hand or via an extension's SQL.

## How to fix

Set the alignment to match the by-value type's size: 1/2/4-byte types align on `int` (or smaller), 8-byte types align on `double` on 64-bit builds. Pass-by-value types must be no larger than the platform Datum. Fix the `CREATE TYPE` alignment, or make the type pass-by-reference if it cannot meet the constraint.

## Example

*Illustrative* — a bad alignment on a by-value type.

```text
ERROR:  alignment "c" is invalid for passed-by-value type of size 8
```

## Related

- [invalid type modifier](./invalid-type-modifier.md)
- [could not determine actual enum type](./could-not-determine-actual-enum-type.md)
