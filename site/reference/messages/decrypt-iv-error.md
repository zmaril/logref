---
message: "decrypt_iv error: %s"
slug: decrypt-iv-error
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_EXTERNAL_ROUTINE_INVOCATION_EXCEPTION
    code: "39000"
call_sites:
  - "postgres/contrib/pgcrypto/pgcrypto.c:439"
reproduced: false
---

# `decrypt_iv error: %s`

## What it means

The `pgcrypto` extension's IV-based symmetric-decryption routine failed. The placeholder is the underlying cipher-library error. The ciphertext, key, IV, or cipher options did not match how the data was encrypted.

## When it happens

It fires from `decrypt_iv()` in `pgcrypto` when the cipher rejects the input — a wrong key or IV, a corrupted ciphertext, or a padding/length mismatch.

## How to fix

Use the same key, IV, cipher, and mode that `encrypt_iv()` used. The IV must be exactly the block size for the cipher. Check that the stored ciphertext is intact. If no IV was used at encryption time, use `decrypt()` instead.

## Example

*Illustrative* — an IV of the wrong length.

```sql
SELECT decrypt_iv(ciphertext, key, 'short', 'aes') FROM vault;  -- decrypt_iv error: ...
```

## Related

- [decrypt error](./decrypt-error.md)
- [encrypt_iv error](./encrypt-iv-error.md)
