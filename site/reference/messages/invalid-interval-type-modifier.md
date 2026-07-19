---
message: "invalid INTERVAL type modifier"
slug: invalid-interval-type-modifier
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/timestamp.c:1084"
  - "postgres/src/backend/utils/adt/timestamp.c:1117"
reproduced: false
---

# `invalid INTERVAL type modifier`

## What it means

An `INTERVAL` type modifier — the field/precision qualifier in `INTERVAL (p)` or `INTERVAL YEAR TO MONTH` and similar — was not a valid combination. The type modifier the parser produced does not correspond to an allowed interval qualifier.

## When it happens

It arises when declaring an interval type with a malformed qualifier, or when a stored type modifier is read back and does not match a known interval field set.

## How to fix

Use a valid interval qualifier: an optional precision `INTERVAL (0..6)`, or a field range such as `INTERVAL YEAR`, `INTERVAL DAY TO SECOND`, and the other documented combinations. Consult the interval type documentation for the allowed field lists.

## Example

*Illustrative* — an interval qualifier that is not allowed.

```sql
SELECT '1'::interval minute to year;  -- invalid interval qualifier
```

## Related

- [invalid INTERVAL typmod 0x](./invalid-interval-typmod-0x.md)
- [length for type cannot exceed](./length-for-type-cannot-exceed.md)
