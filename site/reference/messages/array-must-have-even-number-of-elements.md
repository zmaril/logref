---
message: "array must have even number of elements"
slug: array-must-have-even-number-of-elements
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/hstore/hstore_io.c:742"
  - "postgres/src/backend/replication/logical/logicalfuncs.c:175"
  - "postgres/src/backend/utils/adt/json.c:1396"
  - "postgres/src/backend/utils/adt/jsonb.c:1307"
reproduced: true
---

# `array must have even number of elements`

## What it means

An `hstore` was built from a single array whose length is odd. That constructor treats the array as alternating key/value pairs, so it needs an even number of elements; an odd count leaves a dangling key with no value.

## When it happens

Calling `hstore(text[])` with a one-dimensional array of odd length, intending key/value pairs but supplying an unpaired element.

## How to fix

Ensure the array has an even number of elements, one value for each key. If you have separate key and value arrays, use the two-argument `hstore(keys, values)` form instead, which pairs them positionally.

## Example

*Reproduced* — captured from `reproducers/scenarios/62_contrib_type_input_deep.sql`.

```sql
SELECT hstore(ARRAY['a', 'b', 'c']);
```

Produces:

```text
ERROR:  array must have even number of elements
```

## Related

- [null value not allowed for object key](./null-value-not-allowed-for-object-key.md)
- [multidimensional arrays must have array expressions with matching dimensions](./multidimensional-arrays-must-have-array-expressions-with-matching-dimensions.md)
