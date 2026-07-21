---
message: "destination encoding \"%s\" does not exist"
slug: destination-encoding-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/conversioncmds.c:68"
reproduced: false
---

# `destination encoding "%s" does not exist`

## What it means

`CREATE CONVERSION` named a destination encoding that PostgreSQL does not recognize. The placeholder is the encoding name.

## When it happens

It fires from `CREATE CONVERSION` (or `CREATE DEFAULT CONVERSION`) when the `TO 'encoding'` clause names an encoding that is not one of the supported names.

## How to fix

Use a supported encoding name. List valid names with `SELECT pg_encoding_to_char(i) FROM generate_series(0, 42) i`, or consult the character-set support documentation. Check spelling and case (for example `LATIN1`, `UTF8`).

## Example

*Illustrative* — an unrecognized destination encoding.

```sql
CREATE CONVERSION c FOR 'UTF8' TO 'NOTREAL' FROM f;
-- destination encoding "NOTREAL" does not exist
```

## Related

- [default conversion for to already exists](./default-conversion-for-to-already-exists.md)
- [encoding not supported by ICU](./encoding-not-supported-by-icu.md)
