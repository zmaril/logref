---
message: "type %s is not composite"
slug: type-is-not-composite
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/executor/execExprInterp.c:2511"
  - "postgres/src/backend/utils/adt/expandedrecord.c:97"
  - "postgres/src/backend/utils/adt/expandedrecord.c:229"
  - "postgres/src/backend/utils/cache/typcache.c:1866"
  - "postgres/src/backend/utils/cache/typcache.c:2025"
  - "postgres/src/backend/utils/cache/typcache.c:2172"
  - "postgres/src/backend/utils/fmgr/funcapi.c:569"
  - "postgres/src/pl/plpgsql/src/pl_comp.c:2086"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:7186"
reproduced: false
---

# `type %s is not composite`

## What it means

An operation that requires a composite (row) type was applied to a type that is not composite. The placeholder is the type. Field access (`(x).field`), record expansion, and some function contexts need a composite type, and a scalar or other non-row type does not qualify.

## When it happens

Using `.field` notation on a scalar value, treating a scalar as a record, or a function declared to work on composites receiving a base type. It also appears when a variable typed as a domain or scalar is used where a row is expected.

## How to fix

Use a composite type where one is required — a table row type, a `CREATE TYPE ... AS (...)` composite, or a `record`. If you meant to access a field, ensure the value is actually a row (for example a whole-row reference `t` from a table `t`, not a single column). Cast or restructure so the value is composite.

## Example

*Illustrative* — field access on a scalar.

```sql
SELECT (42).x;
```

Produces:

```text
ERROR:  type integer is not composite
```

## Related

- [return type must be a row type](./return-type-must-be-a-row-type.md)
- [cannot convert whole-row table reference](./cannot-convert-whole-row-table-reference.md)
