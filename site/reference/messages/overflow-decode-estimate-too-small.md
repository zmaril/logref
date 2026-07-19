---
message: "overflow - decode estimate too small"
slug: overflow-decode-estimate-too-small
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/contrib/pgcrypto/pgp-armor.c:370"
  - "postgres/src/backend/utils/adt/encode.c:141"
reproduced: false
---

# `overflow - decode estimate too small`

## What it means

Internal error in an encoding/decoding routine. A buffer sized from an up-front estimate turned out to be too small to hold the decoded output, so the operation aborted rather than overrun the buffer.

## When it happens

It fires from decode paths (such as those in certain contrib or core codec routines) when the estimated output length was undershot. It is a safety check, not a user-configurable condition.

## How to fix

This is an internal guard against a bad size estimate. If it is reproducible, capture the input that triggered it and report it; there is no user-side setting to tune.

## Example

*Illustrative* — a decode buffer estimate that proved too small.

```text
FATAL:  overflow - decode estimate too small
```

## Related

- [overflow - encode estimate too small](./overflow-encode-estimate-too-small.md)
- [segment too big](./segment-too-big.md)
