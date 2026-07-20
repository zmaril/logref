---
message: "cannot escape without active connection"
slug: cannot-escape-without-active-connection
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/common.c:218"
reproduced: false
---

# `cannot escape without active connection`

## What it means

A client library routine that escapes a string for safe inclusion in SQL was called without an active database connection. Correct escaping depends on the connection's character-set encoding, so the routine needs a live connection to work.

## When it happens

It occurs when application code calls a connection-based escaping function — such as `PQescapeStringConn` or `PQescapeLiteral` — before connecting, or after the connection was lost.

## How to fix

Escape strings only after a connection is established, and re-establish the connection before escaping if it dropped. Pass a valid, open connection handle to the escaping routine.

## Example

*Illustrative* — escaping with no connection.

```text
cannot escape without active connection
```

## Related

- [cannot encrypt password with 'plaintext'](./cannot-encrypt-password-with-plaintext.md)
- [cannot create encrypted password](./cannot-create-encrypted-password.md)
