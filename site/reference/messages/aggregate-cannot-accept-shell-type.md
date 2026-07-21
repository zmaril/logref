---
message: "aggregate cannot accept shell type %s"
slug: aggregate-cannot-accept-shell-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:252"
reproduced: false
---

# `aggregate cannot accept shell type %s`

## What it means

A `CREATE AGGREGATE` referenced a shell type — a type name that has been declared but not yet fully defined — as one of its argument or state types, which is not allowed.

## When it happens

It occurs when defining an aggregate that uses a placeholder (shell) type created by a bare `CREATE TYPE name` that has not been completed with its input/output functions.

## How to fix

Finish defining the type (its I/O functions via the full `CREATE TYPE`) before using it in the aggregate, or use an already-complete type. Aggregates need fully defined types for their arguments and transition state.

## Example

*Illustrative* — an aggregate over an incomplete shell type.

```sql
CREATE TYPE myt;  -- shell only
CREATE AGGREGATE a(myt) (...);  -- ERROR:  aggregate cannot accept shell type myt
```

## Related

- [aggregate input type must be specified](./aggregate-input-type-must-be-specified.md)
- [aggregate stype must be specified](./aggregate-stype-must-be-specified.md)
