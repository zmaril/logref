---
message: "enum data types are not binary-compatible"
slug: enum-data-types-are-not-binary-compatible
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1748"
reproduced: false
---

# `enum data types are not binary-compatible`

## What it means

`CREATE CAST ... WITHOUT FUNCTION` (a binary-compatible cast) named an enum type. Enum values are stored as internal OIDs specific to each enum, so no two enum types are binary-compatible.

## When it happens

It fires from `CREATE CAST` when the source or target is an enum type and the cast is declared `WITHOUT FUNCTION`.

## How to fix

Do not create a binary cast for an enum. To convert between enums or between an enum and text, cast through `text` (for example `myenum::text::otherenum`) or write a function-based cast that maps the labels explicitly.

## Example

*Illustrative* — a binary cast on an enum.

```sql
CREATE CAST (color AS mood) WITHOUT FUNCTION;
-- enum data types are not binary-compatible
```

## Related

- [domain data types must not be marked binary-compatible](./domain-data-types-must-not-be-marked-binary-compatible.md)
- [enum label used more than once](./enum-label-used-more-than-once.md)
