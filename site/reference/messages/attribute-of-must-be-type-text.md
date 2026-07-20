---
message: "attribute \"%s\" of \"%s\" must be type TEXT"
slug: attribute-of-must-be-type-text
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TRIGGERED_ACTION_EXCEPTION
    code: "09000"
call_sites:
  - "postgres/contrib/spi/insert_username.c:79"
reproduced: false
---

# `attribute "%s" of "%s" must be type TEXT`

## What it means

An example trigger from the `spi` contrib module was applied to a column that is not of type `text`, which the trigger requires. The placeholders name the column and its table.

## When it happens

It comes from the `autoinc`/`insert_username`/`moddatetime` family of example triggers when the target column's type does not match what the trigger writes.

## How to fix

Point the trigger at a column of the expected type, or change the column's type to `text`. These modules are teaching examples; for production use the corresponding built-in feature where one exists.

## Example

*Illustrative* — the trigger applied to a non-text column.

```text
ERROR:  attribute "note" of "log" must be type TEXT
```

## Related

- [attribute of must be type int4](./attribute-of-must-be-type-int4.md)
- [attribute of must be type timestamp or timestamptz](./attribute-of-must-be-type-timestamp-or-timestamptz.md)
