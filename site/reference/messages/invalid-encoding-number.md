---
message: "invalid encoding number: %d"
slug: invalid-encoding-number
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/mb/conv.c:282"
  - "postgres/src/backend/utils/mb/conv.c:493"
reproduced: false
---

# `invalid encoding number: %d`

## What it means

Internal error. Code was given a character-set encoding identifier outside the range of known encodings. The placeholder is the numeric encoding id.

## When it happens

It fires from encoding-conversion internals when an integer encoding id does not map to a supported encoding. Ordinary use goes through encoding names and does not surface this; it points to an internal inconsistency or a bad extension call.

## How to fix

This is a can't-happen guard for normal SQL. If a custom C function calls encoding APIs with a raw number, validate that id against `pg_char_to_encoding`. Otherwise capture the statement and report a reproducible case.

## Example

*Illustrative* — an out-of-range encoding id.

```text
ERROR:  invalid encoding number: 999
```

## Related

- [invalid client encoding specified](./invalid-client-encoding-specified.md)
- [is not a valid encoding name](./is-not-a-valid-encoding-name-9a7262.md)
