---
message: "COPY format \"%s\" not recognized"
slug: copy-format-not-recognized
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:624"
reproduced: false
---

# `COPY format "%s" not recognized`

## What it means

A `COPY ... WITH (FORMAT ...)` named a format that is not one of the supported values. Only `text`, `csv`, and `binary` are accepted.

## When it happens

It happens on `COPY ... (FORMAT name)` when `name` is misspelled or not a valid format.

## How to fix

Use one of `text`, `csv`, or `binary`. Check the spelling of the format name in the `COPY` options.

## Example

*Illustrative* — an unknown COPY format.

```sql
COPY t TO STDOUT WITH (FORMAT json_lines);
-- ERROR:  COPY format "json_lines" not recognized
```

## Related

- [COPY file signature not recognized](./copy-file-signature-not-recognized.md)
- [COPY can only be used with JSON mode](./copy-can-only-be-used-with-json-mode.md)
