---
message: "cannot set a subfield to DEFAULT"
slug: cannot-set-a-subfield-to-default
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_target.c:519"
reproduced: false
---

# `cannot set a subfield to DEFAULT`

## What it means

An `UPDATE` tried to set a subfield of a composite column to `DEFAULT`. The `DEFAULT` keyword applies to a whole column, not to a field inside a composite value, so it cannot target a subfield.

## When it happens

It occurs when an `UPDATE ... SET col.field = DEFAULT` names a field of a composite-type column.

## How to fix

Set the subfield to an explicit value instead of `DEFAULT`, or assign the whole composite column a value (which may itself be `DEFAULT`). Compute the field's intended value directly.

## Example

*Illustrative* — setting a composite subfield to DEFAULT.

```text
ERROR:  cannot set a subfield to DEFAULT
```

## Related

- [cannot set an array element to DEFAULT](./cannot-set-an-array-element-to-default.md)
- [cannot set value in column to default](./cannot-set-value-in-column-to-default.md)
