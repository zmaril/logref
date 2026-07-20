---
message: "null_value_treatment must be \"delete_key\", \"return_target\", \"use_json_null\", or \"raise_exception\""
slug: null-value-treatment-must-be-delete-key-return-target-use-json-null-or-raise
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4912"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4954"
reproduced: false
---

# `null_value_treatment must be "delete_key", "return_target", "use_json_null", or "raise_exception"`

## What it means

The `null_value_treatment` argument to a jsonb modification function was not one of its allowed keywords. Valid values are `delete_key`, `return_target`, `use_json_null`, and `raise_exception`.

## When it happens

It arises from `jsonb_set_lax(...)` when its `null_value_treatment` argument is given a value outside the accepted set.

## How to fix

Pass one of the four allowed values exactly: `'delete_key'`, `'return_target'`, `'use_json_null'`, or `'raise_exception'`, choosing the behavior you want when the new value is SQL NULL.

## Example

*Illustrative* — an invalid null-treatment keyword.

```sql
SELECT jsonb_set_lax('{}', '{a}', NULL, true, 'ignore');  -- invalid keyword
```

## Related

- [null value cannot be assigned to variable declared NOT NULL](./null-value-cannot-be-assigned-to-variable-declared-not-null.md)
- [key value must be scalar not array composite or json](./key-value-must-be-scalar-not-array-composite-or-json.md)
