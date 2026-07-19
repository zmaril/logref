---
message: "cannot format salt string"
slug: cannot-format-salt-string
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/contrib/pgcrypto/crypt-gensalt.c:220"
reproduced: false
---

# `cannot format salt string`

## What it means

The pgcrypto extension failed to format a salt string while generating a password hash. The salt generator produced a value that did not fit the requested algorithm's encoding.

## When it happens

It occurs inside `gen_salt()` or `crypt()` when the chosen algorithm and parameters cannot be encoded into a valid salt, for example an out-of-range iteration count.

## How to fix

Call `gen_salt()` with a supported algorithm name and an iteration count in the documented range for that algorithm, then pass the result to `crypt()`. Review the pgcrypto documentation for the accepted parameters.

## Example

*Illustrative* — an unencodable salt request.

```text
ERROR:  cannot format salt string
```

## Related

- [cannot generate DDL for invalid database](./cannot-generate-ddl-for-invalid-database.md)
- [cannot merge addresses from different families](./cannot-merge-addresses-from-different-families.md)
