---
message: "could not parse result of current_schemas()"
slug: could-not-parse-result-of-current-schemas
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:3855"
reproduced: false
---

# `could not parse result of current_schemas()`

## What it means

`pg_dump` called `current_schemas()` to learn the active schema search path and could not parse the array it returned. The `%s` result should be an array of schema names. It uses this to qualify object references.

## When it happens

It happens during `pg_dump` when the reply from `current_schemas()` is not in the expected array form — an unusual situation, usually a protocol or version mismatch, or a non-standard server response.

## How to fix

Make sure the client and server versions are compatible and that nothing is intercepting or rewriting query results. If the versions match and the server is stock PostgreSQL, capture the output and report a reproducible case.

## Example

*Illustrative* — an unparsable current_schemas() result.

```text
pg_dump: fatal: could not parse result of current_schemas()
```

## Related

- [could not parse server version](./could-not-parse-server-version.md)
- [could not parse numeric array: invalid character in number](./could-not-parse-numeric-array-invalid-character-in-number.md)
