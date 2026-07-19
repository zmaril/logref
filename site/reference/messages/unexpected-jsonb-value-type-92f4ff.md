---
message: "unexpected jsonb value type: %d"
slug: unexpected-jsonb-value-type-92f4ff
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/jsonb_plperl/jsonb_plperl.c:57"
  - "postgres/contrib/jsonb_plpython/jsonb_plpython.c:129"
reproduced: false
---

# `unexpected jsonb value type: %d`

## What it means

Internal error. Code walking a `jsonb` value found a value-type tag that is not one of the defined kinds (object, array, string, numeric, boolean, null).

## When it happens

It fires from `jsonb` traversal or output routines when the in-memory value carries a type tag outside the known set — a sign of a corrupted or malformed container, not of ordinary input.

## How to fix

This is an internal guard. If it appears from a stored value, the `jsonb` datum may be corrupt; capture the row and column and report it. Re-deriving the value from its source can restore a clean copy.

## Example

*Illustrative* — an out-of-range jsonb value tag.

```text
ERROR:  unexpected jsonb value type: 9
```

## Related

- [unexpected jsonb datetime type oid %u](./unexpected-jsonb-datetime-type-oid.md)
- [unrecognized jsonb type: %d](./unrecognized-jsonb-type.md)
