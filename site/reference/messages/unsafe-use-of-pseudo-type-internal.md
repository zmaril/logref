---
message: "unsafe use of pseudo-type \"internal\""
slug: unsafe-use-of-pseudo-type-internal
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_aggregate.c:511"
  - "postgres/src/backend/catalog/pg_proc.c:230"
  - "postgres/src/backend/catalog/pg_proc.c:259"
reproduced: false
---

# `unsafe use of pseudo-type "internal"`

## What it means

A function was defined in a way that exposes the `internal` pseudo-type unsafely. The `internal` type stands for a C-level pointer and must never be constructible from SQL, so a function that would let SQL produce an `internal` value is rejected.

## When it happens

Creating a function that returns `internal` without also taking an `internal` argument, or an aggregate or definition that would let a SQL caller synthesize an `internal` value. It typically arises when defining low-level support functions incorrectly.

## How to fix

Ensure any function returning `internal` also accepts at least one `internal` argument, so a value can only come from the server, never from SQL. This is a safety rule for extension and type authors; consult the documentation on `internal` when defining support functions and aggregates.

## Example

*Illustrative* — a function returning internal with no internal input.

```sql
CREATE FUNCTION f() RETURNS internal AS ...;  -- unsafe use of "internal"
```

## Related

- [aggregate transition data type cannot be](./aggregate-transition-data-type-cannot-be.md)
- [aggregate needs to have compatible input type and transition type](./aggregate-needs-to-have-compatible-input-type-and-transition-type.md)
