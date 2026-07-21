---
message: "composite type %s cannot be made a member of itself"
slug: composite-type-cannot-be-made-a-member-of-itself
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/catalog/heap.c:625"
reproduced: false
---

# `composite type %s cannot be made a member of itself`

## What it means

A definition would make a composite type contain itself, directly or through a chain of composite fields. A type cannot include itself as a member because that would be infinitely recursive.

## When it happens

It happens on `CREATE TYPE`, `ALTER TYPE ... ADD ATTRIBUTE`, or table changes that would add a column of a composite type to that same type.

## How to fix

Break the recursion. Do not add a column or attribute whose type is (or transitively contains) the composite type being defined. Use a different type, or a reference such as a foreign key, to model the relationship.

## Example

*Illustrative* — a composite type referencing itself.

```sql
CREATE TYPE node AS (val int);
ALTER TYPE node ADD ATTRIBUTE self node;
-- ERROR:  composite type node cannot be made a member of itself
```

## Related

- [composite data types are not binary-compatible](./composite-data-types-are-not-binary-compatible.md)
- [column has pseudo-type](./column-has-pseudo-type.md)
