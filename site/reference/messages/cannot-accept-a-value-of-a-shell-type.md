---
message: "cannot accept a value of a shell type"
slug: cannot-accept-a-value-of-a-shell-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/pseudotypes.c:305"
reproduced: false
---

# `cannot accept a value of a shell type`

## What it means

A value was supplied for a shell type — a placeholder type created by `CREATE TYPE name` with no definition yet. A shell type has no input function, so it cannot hold or accept values until it is fully defined.

## When it happens

It occurs when a type is referenced in a value context while it is still a shell, typically during the intermediate step of defining a type and its input/output functions.

## How to fix

Complete the type definition before using it in values. Create the type's input and output functions and issue the full `CREATE TYPE ... (INPUT = ..., OUTPUT = ...)`, which converts the shell into a usable type.

## Example

*Illustrative* — using a shell type as a value.

```sql
CREATE TYPE mytype;  -- shell only
SELECT 'x'::mytype;
```

## Related

- [calling procedures with output arguments is not supported in sql functions](./calling-procedures-with-output-arguments-is-not-supported-in-sql-functions.md)
- [cannot accumulate empty arrays](./cannot-accumulate-empty-arrays.md)
