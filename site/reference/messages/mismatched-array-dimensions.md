---
message: "mismatched array dimensions"
slug: mismatched-array-dimensions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/contrib/pgcrypto/pgp-pgsql.c:783"
  - "postgres/src/backend/utils/adt/json.c:1488"
  - "postgres/src/backend/utils/adt/jsonb.c:1415"
reproduced: true
---

# `mismatched array dimensions`

## What it means

An operation combined or compared arrays whose dimensions do not agree. Some array operations require the operands to have the same shape, and the arrays supplied did not match in the number or extent of their dimensions.

## When it happens

Element-wise array operations or conversions that expect equal shapes — for example combining two arrays of different lengths, or feeding a jagged or wrong-sized array where a specific shape is required.

## How to fix

Ensure the arrays share the same dimensions before combining them. Check the source of each array, since Postgres arrays are rectangular and an unexpected shape usually comes from constructing one from ragged input. Reshape or pad the data so both operands match.

## Example

*Reproduced* — captured from `reproducers/scenarios/19_json_sqljson.sql`.

```sql
SELECT json_object('{a,b}', '{1}');
```

Produces:

```text
ERROR:  mismatched array dimensions
```

## Related

- [invalid number of dimensions](./invalid-number-of-dimensions.md)
- [number of array dimensions exceeds the maximum allowed](./number-of-array-dimensions-exceeds-the-maximum-allowed-c53afe.md)
