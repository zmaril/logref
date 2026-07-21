---
message: "encrypt error: %s"
slug: encrypt-error
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_EXTERNAL_ROUTINE_INVOCATION_EXCEPTION
    code: "39000"
call_sites:
  - "postgres/contrib/pgcrypto/pgcrypto.c:288"
reproduced: false
---

# `encrypt error: %s`

## What it means

The `pgcrypto` extension's symmetric-encryption routine failed. The placeholder is the underlying cipher-library error. Usually the cipher name, key, or options were invalid.

## When it happens

It fires from `encrypt()` in `pgcrypto` when the block cipher rejects the parameters — for example an unknown cipher/mode name or a key of the wrong length.

## How to fix

Check the cipher spec passed to `encrypt(data, key, 'aes')` — the algorithm and mode must be ones `pgcrypto` supports and the key length must match. Consult the `pgcrypto` documentation for valid cipher strings.

## Example

*Illustrative* — an unknown cipher name.

```sql
SELECT encrypt('secret', 'key', 'nosuchcipher');
-- encrypt error: ...
```

## Related

- [encrypt_iv error](./encrypt-iv-error.md)
- [decrypt error](./decrypt-error.md)
