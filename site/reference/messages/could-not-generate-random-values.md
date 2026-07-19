---
message: "could not generate random values"
slug: could-not-generate-random-values
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/utils/adt/uuid.c:547"
  - "postgres/src/backend/utils/adt/uuid.c:644"
reproduced: false
---

# `could not generate random values`

## What it means

Internal error. The server's strong random-number source failed while generating a UUID (or similar random value). Postgres treats a random-generation failure as unrecoverable for the operation rather than returning a weak value.

## When it happens

The platform random source (for example the kernel entropy device or the OpenSSL RNG) returned an error. It is rare and points at an operating-system or crypto-library problem, not user input.

## How to fix

Check the host's random source and any OpenSSL configuration. On a healthy system this does not occur; if it recurs, inspect kernel logs for entropy-device errors and verify the crypto library is functioning.

## Example

*Illustrative* — the platform RNG failed during `gen_random_uuid()`.

```text
ERROR:  could not generate random values
```

## Related

- [gen_salt](./gen-salt.md)
- [could not encode salt](./could-not-find-tuple-for-cast.md)
