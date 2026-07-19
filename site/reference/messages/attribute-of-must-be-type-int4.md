---
message: "attribute \"%s\" of \"%s\" must be type INT4"
slug: attribute-of-must-be-type-int4
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TRIGGERED_ACTION_EXCEPTION
    code: "09000"
call_sites:
  - "postgres/contrib/spi/autoinc.c:87"
reproduced: false
---

# `attribute "%s" of "%s" must be type INT4`

## What it means

A referential-integrity trigger from the `refint` contrib module was applied to a column whose type is not `int4`. The first placeholder is the column, the second the table; the check enforces the type the trigger expects.

## When it happens

It fires when the `check_primary_key` or `check_foreign_key` triggers in the `spi`/`refint` example module are attached to a column of the wrong type.

## How to fix

These example triggers expect specific column types. Either change the column to `int4`, or use the built-in `FOREIGN KEY` constraint machinery instead of the `refint` example, which exists mainly for demonstration.

## Example

*Illustrative* — the trigger applied to a non-int4 column.

```text
ERROR:  attribute "id" of "orders" must be type INT4
```

## Related

- [attribute of must be type text](./attribute-of-must-be-type-text.md)
- [attribute of must be type timestamp or timestamptz](./attribute-of-must-be-type-timestamp-or-timestamptz.md)
