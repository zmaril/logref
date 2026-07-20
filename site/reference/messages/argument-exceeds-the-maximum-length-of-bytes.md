---
message: "argument exceeds the maximum length of %d bytes"
slug: argument-exceeds-the-maximum-length-of-bytes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/fuzzystrmatch/fuzzystrmatch.c:279"
reproduced: false
---

# `argument exceeds the maximum length of %d bytes`

## What it means

An argument was longer than the maximum byte length the function or context allows, so it was rejected.

## When it happens

It occurs when a value passed to a function, identifier, or protocol field exceeds a fixed size limit — for example an over-long name or a value bound to a fixed-size parameter.

## How to fix

Shorten the argument to within the byte limit stated in the message. If the data legitimately needs to be larger, use a type or interface that supports the size (for example a text/bytea column instead of a fixed-length one), or split the value.

## Example

*Illustrative* — an argument over the byte limit.

```text
ERROR:  argument exceeds the maximum length of 8192 bytes
```

## Related

- [argument must not be null](./argument-must-not-be-null.md)
- [array size exceeds the maximum allowed](./array-size-exceeds-the-maximum-allowed-16139a.md)
