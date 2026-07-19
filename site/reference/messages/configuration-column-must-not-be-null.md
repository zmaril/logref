---
message: "configuration column \"%s\" must not be null"
slug: configuration-column-must-not-be-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/src/backend/utils/adt/tsvector_op.c:2796"
reproduced: false
---

# `configuration column "%s" must not be null`

## What it means

A text-search operation read a null in the column that is supposed to hold the text-search configuration. The configuration cannot be null, because it determines how the document is parsed.

## When it happens

It happens with `tsvector`-maintenance triggers or functions when the configuration column in the processed row is null.

## How to fix

Ensure the configuration column is never null for rows the trigger or function processes, for example by giving it a default or a `NOT NULL` constraint, or by handling nulls before the text-search step.

## Example

*Illustrative* — a null configuration column.

```text
ERROR:  configuration column "cfg" must not be null
```

## Related

- [configuration column does not exist](./configuration-column-does-not-exist.md)
- [column is not of regconfig type](./column-is-not-of-regconfig-type.md)
