---
message: "fixed-size types must have storage PLAIN"
slug: fixed-size-types-must-have-storage-plain
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/catalog/pg_type.c:321"
  - "postgres/src/backend/commands/typecmds.c:4401"
reproduced: false
---

# `fixed-size types must have storage PLAIN`

## What it means

A `CREATE TYPE` (or `ALTER TYPE`) declared a fixed-length base type with a storage strategy other than `PLAIN`. Fixed-size types cannot be TOASTed, so only `PLAIN` storage is valid for them.

## When it happens

Defining a base type with a positive fixed `INTERNALLENGTH` while setting `STORAGE` to `EXTENDED`, `EXTERNAL`, or `MAIN`.

## How to fix

Use `STORAGE PLAIN` for fixed-length types. Only variable-length types (`INTERNALLENGTH = VARIABLE`) may use the TOAST-capable storage strategies.

## Example

*Illustrative* — a fixed-length type with EXTENDED storage.

```text
ERROR:  fixed-size types must have storage PLAIN
```

## Related

- [function should return type](./function-should-return-type.md)
- [final function with extra arguments must not be declared STRICT](./final-function-with-extra-arguments-must-not-be-declared-strict.md)
