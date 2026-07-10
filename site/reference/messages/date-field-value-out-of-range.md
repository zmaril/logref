---
message: "date field value out of range: %d-%02d-%02d"
slug: date-field-value-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_FIELD_OVERFLOW
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:259"
  - "postgres/src/backend/utils/adt/date.c:269"
  - "postgres/src/backend/utils/adt/timestamp.c:594"
reproduced: false
---

# `date field value out of range: %d-%02d-%02d`

**Severity:** ERROR · SQLSTATE `22008` (ERRCODE_DATETIME_FIELD_OVERFLOW)

## What it means

A date was assembled from year, month, and day fields that do not form a real calendar date. The placeholders echo back the numbers that were supplied, so a rendered line looks like `date field value out of range: 2020-13-01`. Unlike a parse error, the individual fields were read fine — they just describe a day that does not exist.

## When it happens

Building a date with `make_date`, or casting a literal such as `'2020-02-30'` where the month is above 12, the day exceeds the length of that month, or a field is zero. It commonly surfaces when day and month have been swapped, or when application code emits a placeholder like month 0.

## How to fix

Correct the field that is out of range — the message prints all three, so compare them against a valid calendar. Watch for day/month order confusion between locales. If the input is user-supplied, validate it before constructing the date, or parse with `to_date` and a strict format mask so bad values are caught deliberately.

## Example

*Illustrative* — the date/time reproducer scenario constructs impossible dates (`09_datetime.sql`).

```sql
SELECT make_date(2020, 13, 1);
```

Produces:

```text
ERROR:  date field value out of range: 2020-13-01
```

## Source

This message text is emitted from 3 call sites:

- [`postgres/src/backend/utils/adt/date.c:259`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/date.c#L259) — ERROR
- [`postgres/src/backend/utils/adt/date.c:269`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/date.c#L269) — ERROR
- [`postgres/src/backend/utils/adt/timestamp.c:594`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/timestamp.c#L594) — ERROR

## SQLSTATE

- `22008` — **ERRCODE_DATETIME_FIELD_OVERFLOW**. Class 22 (Data Exception).

## Related

- [time zone not recognized](./time-zone-not-recognized.md)
- [invalid input syntax for type](./invalid-input-syntax-for-type-1b54ae.md)
