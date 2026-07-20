---
message: "cannot work with arrays containing NULLs"
slug: cannot-work-with-arrays-containing-nulls
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_ELEMENT_ERROR
    code: "2202E"
call_sites:
  - "postgres/contrib/cube/cube.c:156"
  - "postgres/contrib/cube/cube.c:220"
  - "postgres/contrib/cube/cube.c:258"
reproduced: false
---

# `cannot work with arrays containing NULLs`

## What it means

A function (here in the `cube` extension) was given an array that contains NULL elements, which it does not accept. Some array-consuming functions require every element to be non-NULL because a NULL has no meaningful place in their computation.

## When it happens

Passing an array with one or more NULL elements to a function documented to reject them — often an array assembled by `array_agg` or `ARRAY[...]` that included NULLs.

## How to fix

Remove NULLs before calling: filter them in the aggregate (`array_agg(x) FILTER (WHERE x IS NOT NULL)`), use `array_remove(arr, NULL)`, or ensure the source produces no NULLs. If a NULL is meaningful in your data, decide on a sentinel value the function can accept instead.

## Example

*Illustrative* — an array with a NULL element.

```sql
SELECT cube(ARRAY[1, NULL, 3]);  -- cannot work with arrays containing NULLs
```

## Related

- [cannot compare arrays of different element types](./cannot-compare-arrays-of-different-element-types.md)
- [array must not contain nulls](./array-must-not-contain-nulls.md)
