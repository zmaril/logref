---
message: "null value cannot be assigned to variable \"%s\" declared NOT NULL"
slug: null-value-cannot-be-assigned-to-variable-declared-not-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5187"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5282"
reproduced: false
---

# `null value cannot be assigned to variable "%s" declared NOT NULL`

## What it means

A PL/pgSQL variable declared `NOT NULL` was assigned a null value. Such variables must always hold a non-null value. The placeholder is the variable name.

## When it happens

It arises in PL/pgSQL when a `NOT NULL` variable is assigned NULL — directly, from a query that returned no row or a null column, or at declaration without a non-null default.

## How to fix

Ensure the value assigned is never null: give the variable a non-null default, guard the assignment, or use `COALESCE` to substitute a fallback. If the source is a query that may return no row, handle that case explicitly before assigning.

## Example

*Illustrative* — assigning NULL to a NOT NULL variable.

```sql
DECLARE v int NOT NULL := NULL;  -- cannot assign null
```

## Related

- [null value treatment must be delete_key return_target use_json_null or raise](./null-value-treatment-must-be-delete-key-return-target-use-json-null-or-raise.md)
- [invalid transaction termination](./invalid-transaction-termination.md)
