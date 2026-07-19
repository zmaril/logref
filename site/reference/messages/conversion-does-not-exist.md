---
message: "conversion \"%s\" does not exist"
slug: conversion-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:4141"
reproduced: false
---

# `conversion "%s" does not exist`

## What it means

A statement referenced a conversion by name that does not exist in the search path or named schema. The conversion could not be found.

## When it happens

It happens on `DROP CONVERSION`, `ALTER CONVERSION`, or references to a conversion whose name is misspelled or in a different schema.

## How to fix

Use the correct conversion name, schema-qualify it if needed, or add `IF EXISTS` to a drop. List conversions with `\dc` to confirm the name.

## Example

*Illustrative* — referencing a missing conversion.

```sql
DROP CONVERSION missing;
-- ERROR:  conversion "missing" does not exist
```

## Related

- [conversion already exists](./conversion-already-exists.md)
- [constraint for domain does not exist](./constraint-for-domain-does-not-exist.md)
