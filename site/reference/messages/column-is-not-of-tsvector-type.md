---
message: "column \"%s\" is not of tsvector type"
slug: column-is-not-of-tsvector-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/adt/tsvector_op.c:2771"
reproduced: false
---

# `column "%s" is not of tsvector type`

## What it means

A text-search operation expected a `tsvector` column but was pointed at a column of a different type. The target column that stores the parsed document must be `tsvector`.

## When it happens

It happens with `tsvector` maintenance triggers or statistics functions when the destination column is not declared `tsvector`.

## How to fix

Declare the target column as `tsvector`, or correct the column name passed to the trigger or function so it points at the real `tsvector` column.

## Example

*Illustrative* — a non-tsvector destination column.

```text
ERROR:  column "body" is not of tsvector type
```

## Related

- [column is not of regconfig type](./column-is-not-of-regconfig-type.md)
- [column is not of a character type](./column-is-not-of-a-character-type.md)
