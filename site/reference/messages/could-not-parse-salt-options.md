---
message: "could not parse salt options"
slug: could-not-parse-salt-options
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/contrib/pgcrypto/crypt-sha.c:192"
reproduced: false
---

# `could not parse salt options`

## What it means

The `pgcrypto` extension's crypt support parsed the salt string passed to it and found it malformed. The salt encodes the algorithm and cost parameters for password hashing. A bad salt cannot be interpreted.

## When it happens

It happens when calling `crypt()` with a salt whose format is invalid for the chosen algorithm — for example a wrong prefix, an out-of-range cost, or a truncated salt string.

## How to fix

Generate the salt with `gen_salt()` for the algorithm you want (for example `gen_salt('bf', 8)`) and pass that to `crypt()`, rather than constructing a salt string by hand. A well-formed salt from `gen_salt()` resolves it.

## Example

*Illustrative* — a malformed crypt salt.

```sql
SELECT crypt('secret', '$2z$99$badsalt');
-- ERROR:  could not parse salt options
```

## Related

- [could not parse function return value](./could-not-parse-function-return-value.md)
- [could not print extension value in certificate at position](./could-not-print-extension-value-in-certificate-at-position.md)
