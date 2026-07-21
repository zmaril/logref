---
message: "cannot use \"S\" twice"
slug: cannot-use-s-twice
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:1259"
reproduced: true
---

# `cannot use "S" twice`

## What it means

A `to_char` or `to_number` numeric format template used the `S` sign marker more than once. A single `S` sets the sign for the whole number, so a second one is rejected.

## When it happens

It occurs when a formatting template passed to `to_char()` or `to_number()` contains two `S` markers.

## How to fix

Keep a single `S` in the template, placed where you want the sign to appear, and remove the duplicate.

## Example

*Reproduced* — captured from `reproducers/scenarios/17_strings_format_regex.sql`.

```sql
SELECT to_number('12', 'NONSENSE_ZZ');
```

Produces:

```text
ERROR:  cannot use "S" twice
```

## Related

- [cannot use "EEEE" twice](./cannot-use-eeee-twice.md)
- [cannot use "RN" twice](./cannot-use-rn-twice.md)
