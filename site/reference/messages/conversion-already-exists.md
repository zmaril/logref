---
message: "conversion \"%s\" already exists"
slug: conversion-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/catalog/pg_conversion.c:62"
reproduced: false
---

# `conversion "%s" already exists`

## What it means

A `CREATE CONVERSION` used a name already taken by another conversion in the same schema. Conversion names must be unique within a schema.

## When it happens

It happens on `CREATE CONVERSION name ...` when a conversion with that name already exists in the target schema.

## How to fix

Choose a different conversion name, use `CREATE OR REPLACE`-style redefinition where applicable, or drop the existing conversion first. Check existing conversions in the schema.

## Example

*Illustrative* — a duplicate conversion name.

```sql
CREATE CONVERSION myconv FOR 'UTF8' TO 'LATIN1' FROM ...;
CREATE CONVERSION myconv FOR 'UTF8' TO 'LATIN1' FROM ...;
-- ERROR:  conversion "myconv" already exists
```

## Related

- [conversion does not exist](./conversion-does-not-exist.md)
- [constraint for domain already exists](./constraint-for-domain-already-exists-3ea3c5.md)
