---
message: "expected index as targets for verification"
slug: expected-index-as-targets-for-verification-e91a5a
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/contrib/amcheck/verify_common.c:164"
reproduced: false
---

# `expected index as targets for verification`

## What it means

An `amcheck` verification function was given an object that is not an index at all. The functions verify on-disk index structure, so a non-index argument is rejected as the wrong object type.

## When it happens

It fires from `amcheck` functions when the argument resolves to a table, view, or other relation rather than an index.

## How to fix

Pass the name or OID of an index, not a table. To check a table's indexes, look them up first (for example with `\d tablename` or `pg_indexes`) and call the checker on each index. `amcheck` verifies indexes; it does not take base tables directly.

## Example

*Illustrative* — pass an index, not a table.

```sql
SELECT bt_index_check('orders_pkey'::regclass);  -- an index, not orders
```

## Related

- [expected index as targets for verification (wrong access method)](./expected-index-as-targets-for-verification-1e86f0.md)
- [external varlena datum in tuple that references heap row in index](./external-varlena-datum-in-tuple-that-references-heap-row-in-index.md)
