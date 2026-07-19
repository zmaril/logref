---
message: "bogus magic byte found in salt string"
slug: bogus-magic-byte-found-in-salt-string
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pgcrypto/crypt-sha.c:309"
  - "postgres/contrib/pgcrypto/crypt-sha.c:313"
reproduced: false
---

# `bogus magic byte found in salt string`

## What it means

Internal error in pgcrypto. While parsing a salt string for a hashing routine, the code found a control byte that does not match the expected format. It is a consistency check on the internal salt representation.

## When it happens

It should not occur when using pgcrypto's crypt functions normally. Reaching it points to a malformed salt passed internally or an internal inconsistency, not to typical usage.

## How to fix

Treat it as an internal or input-integrity signal. If a salt string is supplied from outside, verify it is a valid salt for the algorithm in use. Otherwise capture the call and report it against the pgcrypto extension.

## Example

*Illustrative* — a malformed salt byte.

```text
ERROR:  bogus magic byte found in salt string
```

## Related

- [invalid salt](./invalid-salt.md)
- [a null isnull pointer was passed](./a-null-isnull-pointer-was-passed.md)
