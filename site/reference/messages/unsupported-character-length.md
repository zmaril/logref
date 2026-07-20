---
message: "unsupported character length %d"
slug: unsupported-character-length
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/mb/conv.c:332"
  - "postgres/src/backend/utils/mb/conv.c:389"
  - "postgres/src/backend/utils/mb/conv.c:543"
reproduced: false
---

# `unsupported character length %d`

## What it means

Internal error. Character-encoding conversion code encountered a multibyte character whose byte length is not one the conversion handles. The message reports the length. It is a consistency check in the encoding-conversion routines.

## When it happens

It should not occur for valid data in a supported encoding. Reaching it points to malformed byte sequences or an internal inconsistency in a conversion, rather than to correctly encoded text.

## How to fix

Treat it as a data-encoding or internal issue. Check whether the input contains bytes that are not valid in the declared encoding, since malformed multibyte sequences can surface here. Identify the value and its client encoding, and correct the encoding of the source data.

## Example

*Illustrative* — an unexpected character byte length.

```text
ERROR:  unsupported character length 5
```

## Related

- [encoding conversion failed without error](./encoding-conversion-failed-without-error.md)
- [destination encoding does not exist](./destination-encoding-does-not-exist.md)
