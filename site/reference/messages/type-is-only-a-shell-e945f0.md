---
message: "type \"%s\" is only a shell"
slug: type-is-only-a-shell-e945f0
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/parser/parse_type.c:276"
  - "postgres/src/backend/utils/cache/typcache.c:488"
  - "postgres/src/backend/utils/cache/typcache.c:543"
  - "postgres/src/pl/plpgsql/src/pl_comp.c:2004"
reproduced: false
---

# `type "%s" is only a shell`

## What it means

A referenced type exists only as a shell — a placeholder registered to allow a type and its I/O functions to reference each other, but not yet completed. The placeholder is the quoted type name. Until the full `CREATE TYPE` runs, the type has no representation and cannot be used.

## When it happens

Declaring input/output/other support functions that name the base type, or otherwise using a type, while it is still just the shell created by a bare `CREATE TYPE name`.

## How to fix

Finish the type definition with the complete `CREATE TYPE name (INPUT = ..., OUTPUT = ..., ...)`. The shell exists precisely so the I/O functions can be created against it first; once the full definition runs, the type becomes usable.

## Example

*Illustrative* — a shell type used before completion.

```sql
CREATE TYPE complex;  -- shell
CREATE FUNCTION complex_out(complex) RETURNS cstring ...;  -- OK, references shell
SELECT '1'::complex;  -- type "complex" is only a shell (until CREATE TYPE completes)
```

## Related

- [type is only a shell](./type-is-only-a-shell-ca526b.md)
- [could not determine data type for argument](./could-not-determine-data-type-for-argument.md)
