---
message: "cannot use \"RN\" twice"
slug: cannot-use-rn-twice
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:1321"
reproduced: false
---

# `cannot use "RN" twice`

## What it means

A `to_char` numeric format template used the Roman-numeral marker `RN` more than once. That marker may appear only a single time, so a second one is rejected.

## When it happens

It occurs when a formatting template passed to `to_char()` contains two `RN` markers.

## How to fix

Keep a single `RN` in the template. `RN` produces a full Roman numeral on its own, so it does not need to be repeated.

## Example

*Illustrative* — a doubled RN marker.

```sql
SELECT to_char(12, 'RNRN');
-- ERROR:  cannot use "RN" twice
```

## Related

- [cannot use "EEEE" twice](./cannot-use-eeee-twice.md)
- [cannot use "S" twice](./cannot-use-s-twice.md)
