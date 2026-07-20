---
message: "cannot use \"EEEE\" twice"
slug: cannot-use-eeee-twice
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:1342"
reproduced: false
---

# `cannot use "EEEE" twice`

## What it means

A `to_char` or `to_number` numeric format template used the scientific-notation marker `EEEE` more than once. That marker may appear only a single time in a template, so a second one is rejected.

## When it happens

It occurs when a formatting template string passed to `to_char()` or `to_number()` contains two `EEEE` markers.

## How to fix

Keep a single `EEEE` in the template. Remove the duplicate and adjust the surrounding digit and sign markers to produce the format you want.

## Example

*Illustrative* — a doubled EEEE marker.

```sql
SELECT to_char(123.45, '9.99EEEEEEEE');
-- ERROR:  cannot use "EEEE" twice
```

## Related

- [cannot use "RN" twice](./cannot-use-rn-twice.md)
- [cannot use "S" twice](./cannot-use-s-twice.md)
