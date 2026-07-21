---
message: "cast from type %s to type %s does not exist"
slug: cast-from-type-to-type-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/utils/cache/lsyscache.c:1241"
reproduced: false
---

# `cast from type %s to type %s does not exist`

## What it means

A `DROP CAST` or a command that depends on a cast referenced a source-to-target type pair that has no defined cast. There is nothing to drop or use, so the operation fails.

## When it happens

It occurs on `DROP CAST (source AS target)` when no such cast exists, or when another statement assumes a cast that was never created.

## How to fix

Confirm the exact source and target types, including any schema qualification. Use `\dC` in psql to list existing casts, and drop or create the correct pair.

## Example

*Illustrative* — dropping a nonexistent cast.

```sql
DROP CAST (int AS mytype);
-- ERROR:  cast from type integer to type mytype does not exist
```

## Related

- [cast from type to type already exists](./cast-from-type-to-type-already-exists.md)
- [cast function must be a normal function](./cast-function-must-be-a-normal-function.md)
