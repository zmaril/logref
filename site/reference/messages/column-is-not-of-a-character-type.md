---
message: "column \"%s\" is not of a character type"
slug: column-is-not-of-a-character-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/adt/tsvector_op.c:2834"
reproduced: false
---

# `column "%s" is not of a character type`

## What it means

A full-text-search operation that updates or reads a document column was pointed at a column whose type is not a character type. The referenced column must hold text so its contents can be tokenized.

## When it happens

It happens with `ts_stat`, trigger-based `tsvector` maintenance, or similar text-search helpers when a configured source column is, say, an integer or a date rather than `text`/`varchar`.

## How to fix

Point the operation at a character-type column, or cast the source value to `text` before it is processed. Check the column names passed to the text-search function or trigger.

## Example

*Illustrative* — a non-text column used as a document source.

```text
ERROR:  column "n" is not of a character type
```

## Related

- [column is not of tsvector type](./column-is-not-of-tsvector-type.md)
- [column is not of regconfig type](./column-is-not-of-regconfig-type.md)
