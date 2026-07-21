---
message: "gen_salt: %s"
slug: gen-salt
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pgcrypto/pgcrypto.c:177"
  - "postgres/contrib/pgcrypto/pgcrypto.c:200"
reproduced: true
---

# `gen_salt: %s`

## What it means

A `pgcrypto` `gen_salt()` call failed and is relaying the reason. The `%s` is the underlying error. The salt could not be generated with the given algorithm or parameters.

## When it happens

Calling `gen_salt(type, ...)` with an unknown algorithm name, an out-of-range iteration count, or another invalid parameter.

## How to fix

Use a supported salt type (`bf`, `md5`, `xdes`, `des`) and valid parameters. The trailing text names the problem; correct the algorithm or count and retry.

## Example

*Reproduced* — captured from `reproducers/scenarios/42_contrib_inspection.sql`.

```sql
SELECT gen_salt('bf', 99);
```

Produces:

```text
ERROR:  gen_salt: Incorrect number of rounds
```

## Related

- [could not generate random values](./could-not-generate-random-values.md)
- [format specifies argument 0, but arguments are numbered from 1](./format-specifies-argument-0-but-arguments-are-numbered-from-1.md)
