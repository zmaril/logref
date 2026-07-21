---
message: "invalid salt"
slug: invalid-salt
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pgcrypto/crypt-blowfish.c:615"
  - "postgres/contrib/pgcrypto/crypt-blowfish.c:628"
  - "postgres/contrib/pgcrypto/crypt-blowfish.c:637"
  - "postgres/contrib/pgcrypto/crypt-des.c:695"
  - "postgres/contrib/pgcrypto/crypt-des.c:743"
  - "postgres/contrib/pgcrypto/crypt-sha.c:138"
reproduced: true
---

# `invalid salt`

## What it means

`pgcrypto`'s `crypt()` was handed a salt string that does not match the format its algorithm expects. Each scheme (bf, md5, xdes, des) encodes its parameters in the salt prefix; a malformed prefix, wrong length, or bad characters are rejected here.

## When it happens

Calling `crypt(password, salt)` with a salt not produced by `gen_salt()` — for example a hand-written string, a salt for the wrong algorithm, or a truncated value.

## How to fix

Always generate the salt with `gen_salt()`, choosing the algorithm you want, and pass that result to `crypt()`. When verifying a stored hash, pass the stored hash itself as the salt argument — it carries the correct prefix.

## Example

*Reproduced* — captured from `reproducers/scenarios/65_contrib_fdw_dblink_crypto.sql`.

```sql
SELECT crypt('pw', '_z');
```

Produces:

```text
ERROR:  invalid salt
```

## Related

- [invalid option](./invalid-option.md)
- [invalid type modifier](./invalid-type-modifier.md)
