---
message: "invalid symbol \"%.*s\" found while decoding base32hex sequence"
slug: invalid-symbol-found-while-decoding-base32hex-sequence
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/encode.c:938"
  - "postgres/src/backend/utils/adt/encode.c:948"
reproduced: false
---

# `invalid symbol "%.*s" found while decoding base32hex sequence`

## What it means

A base32hex-encoded string contained a character outside the base32hex alphabet (`0`-`9` and `A`-`V`). Decoding stopped at the invalid symbol, shown in the message.

## When it happens

It arises when decoding base32hex input — for example in DNS-related or extension functions that use this encoding — where the string includes characters not in the base32hex set or has bad padding.

## How to fix

Provide input drawn only from the base32hex alphabet (`0`-`9`, `A`-`V`), with correct padding. Strip whitespace and separators, and make sure you are not confusing base32hex with standard base32 (which uses a different alphabet).

## Example

*Illustrative* — a non-base32hex character in the input.

```text
ERROR:  invalid symbol "w" found while decoding base32hex sequence
```

## Related

- [invalid hexadecimal digit](./invalid-hexadecimal-digit.md)
- [invalid Unicode escape](./invalid-unicode-escape.md)
