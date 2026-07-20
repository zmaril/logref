---
message: "type %s is only a shell"
slug: type-is-only-a-shell-ca526b
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/utils/cache/lsyscache.c:3201"
  - "postgres/src/backend/utils/cache/lsyscache.c:3234"
  - "postgres/src/backend/utils/cache/lsyscache.c:3267"
  - "postgres/src/backend/utils/cache/lsyscache.c:3300"
reproduced: false
---

# `type %s is only a shell`

## What it means

A type referenced in the command is a shell type — a placeholder created to break a circular dependency between a type and its I/O functions, but not yet completed with a full `CREATE TYPE`. The placeholder is the type name. A shell type has no storage or behavior and cannot be used as a real type until it is finished.

## When it happens

Using a name that was declared with a bare `CREATE TYPE name` (which makes a shell) but never completed with the full input/output-function form, or referencing a base type while its own I/O functions are still being defined.

## How to fix

Complete the type: issue the full `CREATE TYPE name (INPUT = ..., OUTPUT = ..., ...)` to turn the shell into a real type before using it. If the shell was left over from an aborted definition, drop it and define the type properly.

## Example

*Illustrative* — using an unfinished shell type.

```sql
CREATE TYPE mytype;                 -- shell only
CREATE TABLE t (x mytype);           -- type mytype is only a shell
```

## Related

- [type is only a shell](./type-is-only-a-shell-e945f0.md)
- [cannot determine result data type](./cannot-determine-result-data-type.md)
