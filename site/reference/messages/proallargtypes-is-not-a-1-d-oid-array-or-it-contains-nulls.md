---
message: "proallargtypes is not a 1-D Oid array or it contains nulls"
slug: proallargtypes-is-not-a-1-d-oid-array-or-it-contains-nulls
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/namespace.c:1306"
  - "postgres/src/backend/optimizer/util/clauses.c:4980"
  - "postgres/src/backend/utils/fmgr/funcapi.c:1414"
  - "postgres/src/backend/utils/fmgr/funcapi.c:1787"
reproduced: false
---

# `proallargtypes is not a 1-D Oid array or it contains nulls`

## What it means

Internal error. Code reading a function's `pg_proc` row found that `proallargtypes` — the array of all argument type OIDs — was not a one-dimensional OID array without NULLs, as the catalog format requires. It is a structural check on a system catalog column.

## When it happens

It does not arise from ordinary SQL. It indicates a corrupted or hand-edited `pg_proc` row, or a bug in code that wrote that column, rather than anything in a user's function call.

## How to fix

Treat it as catalog corruption. Identify the offending function (the surrounding operation usually names it), and if the `pg_proc` row is damaged, restore from backup; recreating the function with `CREATE OR REPLACE FUNCTION` rewrites the row cleanly. Report reproducible cases not explained by direct catalog tampering.

## Example

*Illustrative* — a malformed pg_proc argument-types array.

```text
ERROR:  proallargtypes is not a 1-D Oid array or it contains nulls
```

## Related

- [proargmodes is not a 1-D char array of length or it contains nulls](./proargmodes-is-not-a-1-d-char-array-of-length-or-it-contains-nulls.md)
- [could not find function definition for function with OID](./could-not-find-function-definition-for-function-with-oid.md)
