---
message: "invalid client encoding \"%s\" specified"
slug: invalid-client-encoding-specified
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:1413"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:570"
reproduced: false
---

# `invalid client encoding "%s" specified`

## What it means

A client requested a client-side character encoding whose name Postgres does not recognize. The connection cannot be set up with an unknown encoding, so it is refused.

## When it happens

It arises at connection time or on `SET client_encoding` when the encoding name is misspelled, unsupported by this build, or not a valid Postgres encoding label.

## How to fix

Use a valid encoding name. List the supported names with `SELECT pg_encoding_to_char(i) FROM generate_series(0,42) i;` or consult the client-encoding documentation. Common correct values are `UTF8`, `LATIN1`, and `WIN1252`.

## Example

*Illustrative* — an unrecognized client encoding.

```text
FATAL:  invalid client encoding "UTF-88" specified
```

## Related

- [invalid encoding number](./invalid-encoding-number.md)
- [is not a valid encoding name](./is-not-a-valid-encoding-name-9a7262.md)
