---
message: "column \"%s\" is not of regconfig type"
slug: column-is-not-of-regconfig-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/adt/tsvector_op.c:2789"
reproduced: false
---

# `column "%s" is not of regconfig type`

## What it means

A text-search helper expected a column holding a `regconfig` value (a text-search configuration reference) but was given a column of another type. The configuration column must be `regconfig`.

## When it happens

It happens with functions such as `ts_stat` or `tsvector`-maintenance triggers when the column named as the text-search configuration is not of type `regconfig`.

## How to fix

Use a `regconfig` column for the configuration, or cast the value with `::regconfig`. Verify the column order and names in the text-search call.

## Example

*Illustrative* — a non-regconfig column used for the configuration.

```text
ERROR:  column "cfg" is not of regconfig type
```

## Related

- [column is not of tsvector type](./column-is-not-of-tsvector-type.md)
- [column is not of a character type](./column-is-not-of-a-character-type.md)
