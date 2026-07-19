---
message: "attribute \"%s\" of \"%s\" must be type TIMESTAMP or TIMESTAMPTZ"
slug: attribute-of-must-be-type-timestamp-or-timestamptz
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TRIGGERED_ACTION_EXCEPTION
    code: "09000"
call_sites:
  - "postgres/contrib/spi/moddatetime.c:117"
reproduced: false
---

# `attribute "%s" of "%s" must be type TIMESTAMP or TIMESTAMPTZ`

## What it means

The `moddatetime` example trigger was attached to a column that is neither `timestamp` nor `timestamptz`, but the trigger stores a modification timestamp there. The placeholders name the column and its table.

## When it happens

It occurs when `moddatetime` is configured with a target column of the wrong type.

## How to fix

Give the trigger a `timestamp` or `timestamptz` column to write into, or change the target column's type to one of those. The trigger writes the current time and needs a timestamp column to hold it.

## Example

*Illustrative* — moddatetime on a non-timestamp column.

```text
ERROR:  attribute "updated" of "doc" must be type TIMESTAMP or TIMESTAMPTZ
```

## Related

- [attribute of must be type text](./attribute-of-must-be-type-text.md)
- [attribute of must be type int4](./attribute-of-must-be-type-int4.md)
