---
message: "expected \"%s\" index as targets for verification"
slug: expected-index-as-targets-for-verification-1e86f0
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/amcheck/verify_common.c:170"
reproduced: false
---

# `expected "%s" index as targets for verification`

## What it means

An `amcheck` verification function was pointed at an object that is an index, but not one of the specific index type the function verifies. The placeholder names the required index access method. `amcheck` only checks the index kinds it supports.

## When it happens

It fires from `amcheck` functions (such as `bt_index_check`) when the argument is an index built with an access method the function does not handle — for example passing a GIN or hash index to the B-tree checker.

## How to fix

Pass an index of the type the function supports. `bt_index_check` and `bt_index_parent_check` verify B-tree indexes only; use the appropriate checker for other access methods. Confirm the index's access method with `\d indexname` or by querying `pg_am`.

## Example

*Illustrative* — B-tree checker needs a B-tree index.

```sql
SELECT bt_index_check('my_btree_index'::regclass);
```

## Related

- [expected index as targets for verification](./expected-index-as-targets-for-verification-e91a5a.md)
- [external varlena datum in tuple that references heap row in index](./external-varlena-datum-in-tuple-that-references-heap-row-in-index.md)
