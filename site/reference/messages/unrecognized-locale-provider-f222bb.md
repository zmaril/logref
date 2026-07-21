---
message: "unrecognized locale provider: %s"
slug: unrecognized-locale-provider-f222bb
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:3406"
  - "postgres/src/bin/pg_dump/pg_dump.c:3399"
reproduced: false
---

# `unrecognized locale provider: %s`

## What it means

Internal error, or a corrupt catalog. Code selecting the locale provider (libc, ICU, or builtin) for a database or collation met a provider code it does not recognize.

## When it happens

It fires where the locale-provider value from a catalog row is switched on and the value is outside the known set — usually an inconsistent `pg_database`/`pg_collation` row rather than user input.

## How to fix

This is a guard over catalog metadata. If it appears at startup or during collation use, the affected catalog row may be inconsistent; capture the database or collation and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized locale provider.

```text
FATAL:  unrecognized locale provider: x
```

## Related

- [unrecognized encoding: "%s"](./unrecognized-encoding-6df687.md)
- [no usable system locales were found](./no-usable-system-locales-were-found.md)
