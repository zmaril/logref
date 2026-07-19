---
message: "invalid input syntax for type %s"
slug: invalid-input-syntax-for-type-6582cf
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TEXT_REPRESENTATION
    code: "22P02"
call_sites:
  - "postgres/src/backend/utils/adt/encode.c:753"
  - "postgres/src/backend/utils/adt/encode.c:818"
reproduced: false
---

# `invalid input syntax for type %s`

## What it means

A text value could not be parsed as the target type. The placeholder names the type; the value did not match the format that type's input function accepts.

## When it happens

It is one of the most common data errors: inserting or casting text that is not a valid literal for the type — a non-numeric string cast to `integer`, a malformed date, a bad UUID, invalid JSON, and so on. It often shows up during `COPY` or bulk loads of dirty data.

## How to fix

Correct the offending value to match the type's expected format, or clean the input before loading. For loads, identify the bad row (the error detail or a narrowing query helps), and either fix the source data or cast through a more permissive intermediate. Validate formats such as dates and UUIDs at the application boundary.

## Example

*Illustrative* — text that is not a valid value for the type.

```sql
SELECT 'abc'::integer;  -- invalid input syntax for type integer
```

## Related

- [invalid input value for enum](./invalid-input-value-for-enum.md)
- [number is out of range](./number-is-out-of-range.md)
