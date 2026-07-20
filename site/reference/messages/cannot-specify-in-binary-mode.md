---
message: "cannot specify %s in BINARY mode"
slug: cannot-specify-in-binary-mode
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/copy.c:792"
  - "postgres/src/backend/commands/copy.c:801"
  - "postgres/src/backend/commands/copy.c:810"
  - "postgres/src/backend/commands/copy.c:883"
reproduced: false
---

# `cannot specify %s in BINARY mode`

## What it means

A `COPY` option that is not valid with binary format was used together with `FORMAT binary`. The placeholder is the option. Binary `COPY` transfers typed binary values, so text/CSV-oriented options like delimiters, quoting, or null strings do not apply.

## When it happens

Running `COPY ... WITH (FORMAT binary, DELIMITER ',', ...)` or otherwise combining a text/CSV-only option with binary mode.

## How to fix

Remove the incompatible option when using binary format, or switch to text/CSV format if you need that option. Binary `COPY` does not use delimiters, quotes, escapes, headers, or null markers — the data is length-prefixed typed values.

## Example

*Illustrative* — a delimiter in binary COPY.

```sql
COPY t FROM STDIN WITH (FORMAT binary, DELIMITER ',');
```

## Related

- [copy requires CSV mode](./copy-requires-csv-mode.md)
- [insufficient data left in message](./insufficient-data-left-in-message.md)
