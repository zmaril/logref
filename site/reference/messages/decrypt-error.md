---
message: "decrypt error: %s"
slug: decrypt-error
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_EXTERNAL_ROUTINE_INVOCATION_EXCEPTION
    code: "39000"
call_sites:
  - "postgres/contrib/pgcrypto/pgcrypto.c:332"
reproduced: false
---

# `decrypt error: %s`

## What it means

The `pgcrypto` extension's symmetric-decryption routine failed. The placeholder is the underlying cipher-library error. It usually means the ciphertext, key, or cipher options did not line up with how the data was encrypted.

## When it happens

It fires from `decrypt()` in `pgcrypto` when the block cipher rejects the input — for example a wrong key, a truncated or corrupted ciphertext, or a padding mismatch.

## How to fix

Confirm you are decrypting with the exact key, cipher, and mode used to encrypt (`decrypt(data, key, 'aes')` must match the `encrypt()` call). Verify the stored ciphertext was not altered or truncated. If you added an IV at encryption time, use `decrypt_iv()` with the same IV.

## Example

*Illustrative* — decrypting with the wrong key.

```sql
SELECT decrypt(ciphertext, 'wrongkey', 'aes') FROM vault;  -- decrypt error: ...
```

## Related

- [decrypt_iv error](./decrypt-iv-error.md)
- [encrypt error](./encrypt-error.md)
