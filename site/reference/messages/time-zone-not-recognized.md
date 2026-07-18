---
message: "time zone \"%s\" not recognized"
slug: time-zone-not-recognized
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/datetime.c:3349"
  - "postgres/src/backend/utils/adt/timestamp.c:524"
reproduced: true
---

# `time zone "%s" not recognized`

**Severity:** ERROR · SQLSTATE `22023` (ERRCODE_INVALID_PARAMETER_VALUE)

## What it means

A time-zone name did not match anything in Postgres's zone database. The placeholder is the name that was supplied. Postgres accepts IANA zone names (`America/New_York`), fixed offsets, and a set of abbreviations — anything else is rejected.

## When it happens

Using `AT TIME ZONE`, `SET timezone`, or a constructor with a misspelled or invented zone, a Windows-style zone name, or an abbreviation Postgres does not carry. It also appears when application config passes an empty or templated value straight through.

## How to fix

Use a canonical IANA name. Query the built-in catalog to find the right one: `SELECT name FROM pg_timezone_names WHERE name ILIKE '%york%'`, and `SELECT abbrev FROM pg_timezone_abbrevs` for the accepted short forms. Prefer full region names over abbreviations, since abbreviations are ambiguous across history and daylight-saving rules.

## Example

*Reproduced* — The date/time reproducer scenario feeds a bogus zone (`09_datetime.sql`).

```sql
SELECT now() AT TIME ZONE 'Nowhere/Nowhere';
```

Produces:

```text
ERROR:  time zone "Nowhere/Nowhere" not recognized
```

## Source

This message text is emitted from 2 call sites:

- [`postgres/src/backend/utils/adt/datetime.c:3349`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/datetime.c#L3349) — ERROR
- [`postgres/src/backend/utils/adt/timestamp.c:524`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/timestamp.c#L524) — ERROR

## SQLSTATE

- `22023` — **ERRCODE_INVALID_PARAMETER_VALUE**. Class 22 (Data Exception).

## Related

- [date field value out of range](./date-field-value-out-of-range.md)
- [invalid input syntax for type](./invalid-input-syntax-for-type-1b54ae.md)
