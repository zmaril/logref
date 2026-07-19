---
message: "composite data types are not binary-compatible"
slug: composite-data-types-are-not-binary-compatible
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1728"
reproduced: false
---

# `composite data types are not binary-compatible`

## What it means

A `CREATE CAST ... WITHOUT FUNCTION` was requested between two composite types. Binary-coercion casts are only allowed between types with identical internal representations, which composite types do not guarantee, so the cast is refused.

## When it happens

It happens on `CREATE CAST (a AS b) WITHOUT FUNCTION` when both `a` and `b` are composite (row) types.

## How to fix

Provide a conversion function for the cast (`CREATE CAST ... WITH FUNCTION`) instead of a binary one, or reconsider whether the cast is needed. Composite types cannot be reinterpreted byte-for-byte.

## Example

*Illustrative* — a binary cast between composite types.

```sql
CREATE CAST (comp_a AS comp_b) WITHOUT FUNCTION;
-- ERROR:  composite data types are not binary-compatible
```

## Related

- [composite type cannot be made a member of itself](./composite-type-cannot-be-made-a-member-of-itself.md)
- [column cannot be cast automatically to type](./column-cannot-be-cast-automatically-to-type.md)
