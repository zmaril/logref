---
message: "cannot change routine kind"
slug: cannot-change-routine-kind
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/catalog/pg_aggregate.c:705"
  - "postgres/src/backend/catalog/pg_proc.c:412"
reproduced: false
---

# `cannot change routine kind`

## What it means

A `CREATE OR REPLACE` tried to redefine an existing routine as a different kind than it already is — for example replacing a function with a procedure, or an aggregate with a plain function. The kind of a routine is fixed once created.

## When it happens

`CREATE OR REPLACE FUNCTION` naming something that already exists as a procedure or aggregate (or the reverse), usually from a migration that changed a routine's kind without dropping the old one first.

## How to fix

Drop the existing routine with the matching `DROP FUNCTION`/`DROP PROCEDURE`/`DROP AGGREGATE` and create it fresh as the new kind. `CREATE OR REPLACE` can only replace a routine with one of the same kind.

## Example

*Illustrative* — replacing a function with a procedure of the same name.

```text
ERROR:  cannot change routine kind
DETAIL:  "foo" is a function.
```

## Related

- [cannot change owner of index](./cannot-change-owner-of-index.md)
- [could not find a function named](./could-not-find-a-function-named.md)
