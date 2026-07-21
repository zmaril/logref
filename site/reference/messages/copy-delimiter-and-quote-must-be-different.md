---
message: "COPY delimiter and quote must be different"
slug: copy-delimiter-and-quote-must-be-different
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:903"
reproduced: true
---

# `COPY delimiter and quote must be different`

## What it means

A CSV `COPY` set the delimiter and the quote character to the same value. They must differ so the parser can tell field boundaries from quoted values.

## When it happens

It happens on `COPY ... WITH (FORMAT csv, DELIMITER 'x', QUOTE 'x')` when both are the same character.

## How to fix

Set the delimiter and quote to different characters. For example, keep the default quote `"` and use `,` or another distinct delimiter.

## Example

*Reproduced* — captured from `reproducers/scenarios/34_guc_vacuum_copy_xml.sql`.

```sql
COPY repro.parent TO STDOUT WITH (FORMAT csv, DELIMITER ',', QUOTE ',');
```

Produces:

```text
ERROR:  COPY delimiter and quote must be different
```

## Related

- [COPY delimiter cannot be](./copy-delimiter-cannot-be.md)
- [COPY quote must be a single one-byte character](./copy-quote-must-be-a-single-one-byte-character.md)
