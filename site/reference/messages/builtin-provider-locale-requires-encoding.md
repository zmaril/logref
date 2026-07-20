---
message: "builtin provider locale \"%s\" requires encoding \"%s\""
slug: builtin-provider-locale-requires-encoding
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:2810"
reproduced: false
---

# `builtin provider locale "%s" requires encoding "%s"`

## What it means

A collation using the built-in locale provider was created or a database initialized with a built-in locale that only works with a specific encoding, but a different encoding was requested. The placeholders are the locale and the required encoding.

## When it happens

It occurs during `initdb`, `CREATE DATABASE`, or `CREATE COLLATION` with `provider = builtin` when the chosen locale, such as `C.UTF-8`, does not match the target encoding.

## How to fix

Use the encoding the built-in locale requires — for example `UTF8` with `C.UTF-8` — or choose a built-in locale compatible with your intended encoding. The plain `C` locale works with any encoding; the UTF-8 variants require `UTF8`.

## Example

*Illustrative* — a built-in locale with the wrong encoding.

```text
FATAL:  builtin provider locale "C.UTF-8" requires encoding "UTF8"
```

## Related

- [cannot alter multirange type](./cannot-alter-multirange-type.md)
- [can only be executed as a top-level statement](./can-only-be-executed-as-a-top-level-statement.md)
