---
message: "COPY %s requires CSV mode"
slug: copy-requires-csv-mode
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copy.c:892"
  - "postgres/src/backend/commands/copy.c:909"
  - "postgres/src/backend/commands/copy.c:921"
  - "postgres/src/backend/commands/copy.c:936"
  - "postgres/src/backend/commands/copy.c:952"
reproduced: false
---

# `COPY %s requires CSV mode`

## What it means

A `COPY` option that is only meaningful in CSV mode was used without selecting CSV format. The placeholder is the option. Options like `QUOTE`, `ESCAPE`, `FORCE_QUOTE`, `FORCE_NOT_NULL`, and `HEADER` (in older forms) belong to CSV handling.

## When it happens

Running `COPY ... WITH (FORMAT text, QUOTE '"')` or otherwise combining a CSV-only option with the default text format or with binary format.

## How to fix

Add `FORMAT csv` to the `COPY` options so the CSV-specific option applies, or remove the option if you intend text/binary format. In text mode, use the text-format equivalents (`DELIMITER`, `NULL`) instead.

## Example

*Illustrative* — a CSV-only option in text mode.

```sql
COPY t FROM STDIN WITH (FORMAT text, QUOTE '"');
```

## Related

- [cannot specify in binary mode](./cannot-specify-in-binary-mode.md)
- [argument to option must be a list of column names](./argument-to-option-must-be-a-list-of-column-names.md)
