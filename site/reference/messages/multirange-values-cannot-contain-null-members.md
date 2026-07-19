---
message: "multirange values cannot contain null members"
slug: multirange-values-cannot-contain-null-members
passthrough: false
api: [elog, ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/src/backend/utils/adt/multirangetypes.c:978"
  - "postgres/src/backend/utils/adt/multirangetypes.c:1011"
  - "postgres/src/backend/utils/adt/multirangetypes.c:1046"
reproduced: false
---

# `multirange values cannot contain null members`

## What it means

A multirange was constructed with a null range among its members. A multirange is an ordered set of non-null ranges, so a null member is not allowed.

## When it happens

Building a multirange from ranges where one element evaluated to `NULL` — for example a range constructor that returned null, or an array of ranges containing a null entry passed to a multirange constructor.

## How to fix

Remove or replace the null range before constructing the multirange. Filter nulls out of the input, or guard the range-producing expression so it yields an empty range rather than null when appropriate.

## Example

*Illustrative* — a null member in a multirange.

```sql
SELECT int4multirange(int4range(1,5), NULL);  -- null member not allowed
```

## Related

- [type is not a multirange type](./type-is-not-a-multirange-type.md)
- [upper bound cannot be less than lower bound](./upper-bound-cannot-be-less-than-lower-bound.md)
