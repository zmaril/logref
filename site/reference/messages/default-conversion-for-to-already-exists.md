---
message: "default conversion for %s to %s already exists"
slug: default-conversion-for-to-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/catalog/pg_conversion.c:75"
reproduced: false
---

# `default conversion for %s to %s already exists`

## What it means

`CREATE DEFAULT CONVERSION` tried to register a default encoding conversion for a source/destination encoding pair that already has one. The placeholders are the source and destination encoding names. Only one default conversion may exist per pair.

## When it happens

It fires from `CREATE DEFAULT CONVERSION` when a default conversion between those two encodings is already defined.

## How to fix

There can be only one default conversion per encoding pair. Drop the existing one with `DROP CONVERSION` first, or create the conversion without the `DEFAULT` keyword so it is a named, non-default conversion. Query `pg_conversion` (`condefault = true`) to see the current default.

## Example

*Illustrative* — a second default for the same pair.

```sql
CREATE DEFAULT CONVERSION myconv FOR 'UTF8' TO 'LATIN1' FROM myfunc;
-- default conversion for UTF8 to LATIN1 already exists
```

## Related

- [default conversion function for encoding to ... does not exist](./default-conversion-function-for-encoding-to-does-not-exist.md)
- [destination encoding does not exist](./destination-encoding-does-not-exist.md)
