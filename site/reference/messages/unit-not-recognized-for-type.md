---
message: "unit \"%s\" not recognized for type %s"
slug: unit-not-recognized-for-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:1255"
  - "postgres/src/backend/utils/adt/date.c:2347"
  - "postgres/src/backend/utils/adt/date.c:3156"
  - "postgres/src/backend/utils/adt/timestamp.c:4832"
  - "postgres/src/backend/utils/adt/timestamp.c:5085"
  - "postgres/src/backend/utils/adt/timestamp.c:5252"
  - "postgres/src/backend/utils/adt/timestamp.c:5461"
  - "postgres/src/backend/utils/adt/timestamp.c:5759"
  - "postgres/src/backend/utils/adt/timestamp.c:6031"
  - "postgres/src/backend/utils/adt/timestamp.c:6072"
  - "postgres/src/backend/utils/adt/timestamp.c:6309"
reproduced: false
---

# `unit "%s" not recognized for type %s`

## What it means

A date/time function was given a field-unit name it does not recognize at all for the type. The first placeholder is the unit string, the second the type. Unlike "not supported for type" (a known unit that does not apply), this is an unknown unit name.

## When it happens

`EXTRACT`/`date_part`/`date_trunc` with a misspelled or invalid unit — `EXTRACT(' hour' FROM ...)`, `date_trunc('weekk', ...)`, or a unit that simply does not exist. The typo or bad keyword is the cause.

## How to fix

Use a valid unit spelled correctly: `century`, `year`, `quarter`, `month`, `week`, `day`, `hour`, `minute`, `second`, `epoch`, and so on. Check the `EXTRACT`/`date_trunc` documentation for the exact accepted names. Watch for stray spaces or plurals.

## Example

*Illustrative* — a misspelled unit.

```sql
SELECT date_trunc('weekk', now());
```

Produces:

```text
ERROR:  unit "weekk" not recognized for type timestamp with time zone
```

## Related

- [unit not supported for type](./unit-not-supported-for-type.md)
- [timestamp out of range](./timestamp-out-of-range-2f12c7.md)
