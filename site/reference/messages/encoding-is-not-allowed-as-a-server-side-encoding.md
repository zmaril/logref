---
message: "Encoding \"%s\" is not allowed as a server-side encoding."
slug: encoding-is-not-allowed-as-a-server-side-encoding
passthrough: false
api: [pg_log_error_detail]
level: [ERROR]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:2784"
reproduced: false
---

# `Encoding "%s" is not allowed as a server-side encoding.`

## What it means

`initdb` was asked to create a cluster with an encoding that PostgreSQL permits only on the client side, never as the server/database encoding. The placeholder is the encoding name. Some encodings (such as `SJIS`, `BIG5`) may only be a `client_encoding`.

## When it happens

It fires during `initdb` (or `CREATE DATABASE`) when the chosen encoding is client-only.

## How to fix

Choose a valid server-side encoding, typically `UTF8`, and set the client-only encoding with `client_encoding` per session instead. `UTF8` interoperates with client-only encodings through automatic conversion.

## Example

*Illustrative* — a client-only encoding for the server.

```text
initdb: error detail: Encoding "SJIS" is not allowed as a server-side encoding.
```

## Related

- [encoding does not match locale](./encoding-does-not-match-locale.md)
- [encoding conversion to or from SQL_ASCII is not supported](./encoding-conversion-to-or-from-sql-ascii-is-not-supported.md)
