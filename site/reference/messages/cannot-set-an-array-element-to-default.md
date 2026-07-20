---
message: "cannot set an array element to DEFAULT"
slug: cannot-set-an-array-element-to-default
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_target.c:514"
reproduced: false
---

# `cannot set an array element to DEFAULT`

## What it means

An `UPDATE` tried to set an individual array element to `DEFAULT`. The `DEFAULT` keyword applies to a whole column, not to one element of an array, so it cannot target a single element.

## When it happens

It occurs when an `UPDATE ... SET arr[1] = DEFAULT` names an array element.

## How to fix

Assign the array element an explicit value instead of `DEFAULT`, or set the whole array column at once. Build the element's intended value directly.

## Example

*Illustrative* — setting an array element to DEFAULT.

```text
ERROR:  cannot set an array element to DEFAULT
```

## Related

- [cannot set a subfield to DEFAULT](./cannot-set-a-subfield-to-default.md)
- [cannot set value in column to default](./cannot-set-value-in-column-to-default.md)
