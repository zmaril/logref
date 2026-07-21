---
message: "target key array length must match number of key attributes"
slug: target-key-array-length-must-match-number-of-key-attributes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/contrib/dblink/dblink.c:1673"
  - "postgres/contrib/dblink/dblink.c:1745"
  - "postgres/contrib/dblink/dblink.c:1838"
reproduced: false
---

# `target key array length must match number of key attributes`

## What it means

A dblink call that builds a query from key columns and values was given a key array whose length does not match the number of key attributes the operation expects. The two must correspond one to one.

## When it happens

Calling a `dblink` helper such as the build-insert/update/delete functions with a target-key array whose element count differs from the number of primary-key attributes reported for the relation.

## How to fix

Make the key array's length equal the number of key attributes. Fetch the correct key-attribute count for the relation, and supply exactly that many key values in the array, in the matching order.

## Example

*Illustrative* — a key array of the wrong length.

```sql
SELECT dblink_build_sql_insert('t', '1'::int2vector, 2, ...);  -- key array must match attribute count
```

## Related

- [mismatched array dimensions](./mismatched-array-dimensions.md)
- [invalid number of dimensions](./invalid-number-of-dimensions.md)
