---
message: "invalid INTERVAL typmod: 0x%x"
slug: invalid-interval-typmod-0x
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/timestamp.c:1189"
  - "postgres/src/backend/utils/adt/timestamp.c:1249"
reproduced: false
---

# `invalid INTERVAL typmod: 0x%x`

## What it means

Internal error. The packed type modifier for an `INTERVAL` value has a bit pattern that does not decode to a valid interval field/precision qualifier. The placeholder is the raw modifier in hex.

## When it happens

It fires when interval code unpacks a stored typmod and finds it malformed. Ordinary interval use does not surface it; it points to a corrupted stored type modifier or an internal inconsistency.

## How to fix

This is a can't-happen guard. If a specific column reports it, inspect its declared type; recreating the column with a correct interval qualifier rewrites the typmod. Capture the definition and report a reproducible case.

## Example

*Illustrative* — a malformed interval type modifier.

```text
ERROR:  invalid INTERVAL typmod: 0x7fffffff
```

## Related

- [invalid INTERVAL type modifier](./invalid-interval-type-modifier.md)
- [invalid datum pointer](./invalid-datum-pointer.md)
