---
message: "proargmodes is not a 1-D char array of length %d or it contains nulls"
slug: proargmodes-is-not-a-1-d-char-array-of-length-or-it-contains-nulls
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/analyze.c:3665"
  - "postgres/src/backend/utils/fmgr/funcapi.c:1460"
  - "postgres/src/backend/utils/fmgr/funcapi.c:1561"
  - "postgres/src/backend/utils/fmgr/funcapi.c:1794"
reproduced: false
---

# `proargmodes is not a 1-D char array of length %d or it contains nulls`

## What it means

Internal error. Reading a function's `pg_proc` row, code found `proargmodes` — the per-argument mode array (in/out/inout/variadic/table) — was not a one-dimensional char array of the expected length without NULLs. The placeholder is the length it expected. It is a structural check on the catalog column.

## When it happens

Not reachable through ordinary SQL. It points to a corrupted or improperly written `pg_proc` row rather than to a user's call.

## How to fix

Treat it as catalog corruption. Recreate the function with `CREATE OR REPLACE FUNCTION` to rewrite the row, or restore from backup if `pg_proc` itself is damaged. Report reproducible cases that are not the result of manual catalog edits.

## Example

*Illustrative* — a malformed pg_proc argument-modes array.

```text
ERROR:  proargmodes is not a 1-D char array of length 3 or it contains nulls
```

## Related

- [proallargtypes is not a 1-D Oid array or it contains nulls](./proallargtypes-is-not-a-1-d-oid-array-or-it-contains-nulls.md)
- [cannot determine result data type](./cannot-determine-result-data-type.md)
