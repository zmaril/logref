---
message: "encrypt_iv error: %s"
slug: encrypt-iv-error
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_EXTERNAL_ROUTINE_INVOCATION_EXCEPTION
    code: "39000"
call_sites:
  - "postgres/contrib/pgcrypto/pgcrypto.c:385"
reproduced: false
---

# `encrypt_iv error: %s`

## What it means

The `pgcrypto` extension's IV-based symmetric-encryption routine failed. The placeholder is the underlying cipher-library error. The cipher name, key, IV, or options were invalid.

## When it happens

It fires from `encrypt_iv()` in `pgcrypto` when the cipher rejects the parameters — an unknown cipher/mode, a wrong-length key, or an IV that is not the block size.

## How to fix

Verify the cipher spec, the key length, and the IV length in `encrypt_iv(data, key, iv, 'aes')`. The IV must equal the cipher's block size. Consult the `pgcrypto` documentation for valid arguments.

## Example

*Illustrative* — an IV of the wrong length.

```sql
SELECT encrypt_iv('secret', 'key', 'x', 'aes');
-- encrypt_iv error: ...
```

## Related

- [encrypt error](./encrypt-error.md)
- [decrypt_iv error](./decrypt-iv-error.md)
