---
message: "\"%s\" is not a %s index"
slug: is-not-a-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/contrib/pageinspect/brinfuncs.c:169"
  - "postgres/contrib/pageinspect/btreefuncs.c:229"
  - "postgres/contrib/pageinspect/btreefuncs.c:862"
  - "postgres/contrib/pageinspect/gistfuncs.c:222"
  - "postgres/contrib/pageinspect/hashfuncs.c:425"
reproduced: false
---

# `"%s" is not a %s index`

## What it means

An inspection function was pointed at a relation, but that relation is not an index of the required kind. The placeholders are the object name and the expected index type. Functions like the `pageinspect` BRIN routines only work on indexes of their specific access method.

## When it happens

Calling an access-method-specific inspection function (for example a BRIN or hash `pageinspect` routine) on a table, a view, or an index of a different type than the function handles.

## How to fix

Pass an index of the exact type the function expects. Verify the object with `\d name` and choose the inspection function matching its access method. For general index inspection, use the routine that corresponds to that index's method.

## Example

*Illustrative* — a non-BRIN index passed to a BRIN function.

```text
ERROR:  "t_pkey" is not a BRIN index
```

## Related

- [is not an index](./is-not-an-index.md)
- [invalid overflow block number](./invalid-overflow-block-number.md)
