---
message: "cast from type %s to type %s already exists"
slug: cast-from-type-to-type-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/catalog/pg_cast.c:73"
reproduced: false
---

# `cast from type %s to type %s already exists`

## What it means

A `CREATE CAST` tried to define a cast between two types that already has one. Only one cast may exist for a given source-to-target type pair, so the duplicate is rejected.

## When it happens

It occurs on `CREATE CAST (source AS target)` when a cast between those types is already registered.

## How to fix

Drop the existing cast with `DROP CAST (source AS target)` before recreating it, or adjust the existing one instead of adding a new one. Use `CREATE OR REPLACE`-style workflows by dropping first.

## Example

*Illustrative* — a duplicate cast.

```sql
CREATE CAST (int AS mytype) WITH FUNCTION f(int);
-- ERROR:  cast from type integer to type mytype already exists
```

## Related

- [cast from type to type does not exist](./cast-from-type-to-type-does-not-exist.md)
- [cast function must be a normal function](./cast-function-must-be-a-normal-function.md)
