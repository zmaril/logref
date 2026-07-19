---
message: "unexpected jsonb datetime type oid %u"
slug: unexpected-jsonb-datetime-type-oid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execExprInterp.c:5158"
  - "postgres/src/backend/utils/adt/jsonb_util.c:919"
reproduced: false
---

# `unexpected jsonb datetime type oid %u`

## What it means

Internal error. While formatting a `jsonb` value that holds a date/time, the code met a type OID that is not one of the datetime types it knows how to render.

## When it happens

It fires deep in `jsonb` output when the stored datetime subtype does not match any expected case. It points to an inconsistency in how the value was built rather than to user input.

## How to fix

This is an internal guard. If a real query provokes it, capture the value and the expression that produced it and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized datetime OID inside jsonb.

```text
ERROR:  unexpected jsonb datetime type oid 12345
```

## Related

- [unexpected jsonb value type: %d](./unexpected-jsonb-value-type-92f4ff.md)
- [unrecognized jsonb type: %d](./unrecognized-jsonb-type.md)
