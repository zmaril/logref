---
message: "crypt(3) returned NULL"
slug: crypt-3-returned-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_EXTERNAL_ROUTINE_INVOCATION_EXCEPTION
    code: "39000"
call_sites:
  - "postgres/contrib/pgcrypto/pgcrypto.c:234"
reproduced: false
---

# `crypt(3) returned NULL`

## What it means

The `pgcrypto` extension called the system `crypt` password-hashing routine and it returned nothing. The server reports this as an external-routine failure. `crypt` normally returns a hashed string.

## When it happens

It fires inside `pgcrypto`'s `crypt()` function when the underlying system routine yields a null result, usually because it was given a salt or algorithm identifier it does not accept.

## How to fix

Check the salt you passed to `crypt()`. Generate it with `gen_salt()` for the algorithm you intend (for example `gen_salt('bf')` for Blowfish), rather than supplying a hand-built salt string. An unsupported or malformed salt makes the system routine fail.

## Example

*Illustrative* — a malformed salt.

```sql
SELECT crypt('secret', 'not-a-valid-salt');
-- ERROR:  crypt(3) returned NULL
```

## Related

- [current database's encoding is not supported with this provider](./current-database-s-encoding-is-not-supported-with-this-provider.md)
- [data type is a pseudo-type](./data-type-is-a-pseudo-type.md)
