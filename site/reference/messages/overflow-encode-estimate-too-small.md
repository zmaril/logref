---
message: "overflow - encode estimate too small"
slug: overflow-encode-estimate-too-small
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/contrib/pgcrypto/pgp-armor.c:227"
  - "postgres/src/backend/utils/adt/encode.c:91"
reproduced: false
---

# `overflow - encode estimate too small`

## What it means

Internal error in an encoding routine. The buffer sized from an up-front estimate was too small to hold the encoded output, so the routine aborted to avoid overrunning it.

## When it happens

It fires from encode paths when the estimated output length was undershot. It is a safety check rather than a user-configurable condition.

## How to fix

This is an internal guard against a bad size estimate. If reproducible, capture the triggering input and report it; there is no user-side knob for it.

## Example

*Illustrative* — an encode buffer estimate that proved too small.

```text
FATAL:  overflow - encode estimate too small
```

## Related

- [overflow - decode estimate too small](./overflow-decode-estimate-too-small.md)
- [segment too big](./segment-too-big.md)
