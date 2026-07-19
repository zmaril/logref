---
message: "cannot create temporary tables during a parallel operation"
slug: cannot-create-temporary-tables-during-a-parallel-operation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_READ_ONLY_SQL_TRANSACTION
    code: "25006"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:4504"
reproduced: false
---

# `cannot create temporary tables during a parallel operation`

## What it means

Code tried to create a temporary table while a parallel operation was active. Temporary tables are session-local objects that parallel workers cannot create, so this is forbidden inside parallel mode.

## When it happens

It occurs when a function invoked during parallel query or a parallel utility issues a `CREATE TEMP TABLE`.

## How to fix

Keep temporary-table creation out of parallel-executed code. Mark functions that create temporary tables as `PARALLEL UNSAFE`, or create the table before the parallel operation begins.

## Example

*Illustrative* — a temp table in parallel mode.

```text
ERROR:  cannot create temporary tables during a parallel operation
```

## Related

- [cannot create temporary tables during recovery](./cannot-create-temporary-tables-during-recovery.md)
- [cannot create temporary table within security-restricted operation](./cannot-create-temporary-table-within-security-restricted-operation.md)
