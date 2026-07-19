---
message: "unexpected number of armor header lines"
slug: unexpected-number-of-armor-header-lines
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pgcrypto/pgp-armor.c:473"
  - "postgres/contrib/pgcrypto/pgp-armor.c:484"
reproduced: false
---

# `unexpected number of armor header lines`

## What it means

The pgcrypto armor decoder found a header block whose line count does not match what ASCII-armored (PEM-style) data should contain, so it rejected the input.

## When it happens

It arises from `pgcrypto`'s `pgp_armor` / `dearmor` functions when the armored text is malformed — extra or missing header lines, or data that was never valid armor.

## How to fix

Check that the input is well-formed ASCII armor with a single header block. Re-export or re-copy the armored text, watching for line-ending mangling or accidental concatenation of two armored blocks.

## Example

*Illustrative* — dearmoring malformed input.

```text
ERROR:  unexpected number of armor header lines
```

## Related

- [uuid library failure: %d](./uuid-library-failure.md)
- [unrecognized encoding: "%s"](./unrecognized-encoding-6df687.md)
