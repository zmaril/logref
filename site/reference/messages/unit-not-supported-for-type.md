---
message: "unit \"%s\" not supported for type %s"
slug: unit-not-supported-for-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:1147"
  - "postgres/src/backend/utils/adt/date.c:1230"
  - "postgres/src/backend/utils/adt/date.c:1246"
  - "postgres/src/backend/utils/adt/date.c:2331"
  - "postgres/src/backend/utils/adt/date.c:3136"
  - "postgres/src/backend/utils/adt/timestamp.c:4727"
  - "postgres/src/backend/utils/adt/timestamp.c:4818"
  - "postgres/src/backend/utils/adt/timestamp.c:4967"
  - "postgres/src/backend/utils/adt/timestamp.c:5068"
  - "postgres/src/backend/utils/adt/timestamp.c:5186"
  - "postgres/src/backend/utils/adt/timestamp.c:5238"
  - "postgres/src/backend/utils/adt/timestamp.c:5501"
  - "postgres/src/backend/utils/adt/timestamp.c:5703"
  - "postgres/src/backend/utils/adt/timestamp.c:5750"
  - "postgres/src/backend/utils/adt/timestamp.c:5975"
  - "postgres/src/backend/utils/adt/timestamp.c:6022"
  - "postgres/src/backend/utils/adt/timestamp.c:6103"
  - "postgres/src/backend/utils/adt/timestamp.c:6248"
reproduced: true
---

# `unit "%s" not supported for type %s`

## What it means

A date/time function was given a field unit that is valid in general but not meaningful for the specific type. For example asking for a time-of-day field from a bare `date`, or a date field from a `time`. The first placeholder is the unit, the second the type.

## When it happens

`EXTRACT`, `date_part`, `date_trunc`, or `date_bin` with a unit the argument type does not carry — extracting `hour` from a `date`, or `year` from a `time`. The unit is recognized but does not apply to that type's components.

## How to fix

Use a unit that exists for the type, or cast the value to a type that has the field you want. To get time-of-day fields, work with `timestamp`/`time`; to get date fields, work with `date`/`timestamp`. Check the extract/date_part documentation for which units apply to which types.

## Example

*Reproduced* — captured from `reproducers/scenarios/31_type_io_datetime.sql`.

```sql
SELECT extract(timezone FROM time '12:00:00');
```

Produces:

```text
ERROR:  unit "timezone" not supported for type time without time zone
```

## Related

- [unit not recognized for type](./unit-not-recognized-for-type.md)
- [timestamp out of range](./timestamp-out-of-range-2f12c7.md)
