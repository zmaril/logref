---
message: "invalid preceding or following size in window function"
slug: invalid-preceding-or-following-size-in-window-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PRECEDING_OR_FOLLOWING_SIZE
    code: "22013"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:2230"
  - "postgres/src/backend/utils/adt/date.c:2788"
  - "postgres/src/backend/utils/adt/float.c:1082"
  - "postgres/src/backend/utils/adt/float.c:1158"
  - "postgres/src/backend/utils/adt/int.c:662"
  - "postgres/src/backend/utils/adt/int.c:709"
  - "postgres/src/backend/utils/adt/int.c:744"
  - "postgres/src/backend/utils/adt/int8.c:418"
  - "postgres/src/backend/utils/adt/numeric.c:2602"
  - "postgres/src/backend/utils/adt/timestamp.c:3868"
  - "postgres/src/backend/utils/adt/timestamp.c:3905"
  - "postgres/src/backend/utils/adt/timestamp.c:3946"
reproduced: false
---

# `invalid preceding or following size in window function`

## What it means

A window frame's `PRECEDING`/`FOLLOWING` offset was invalid — negative, NULL, or otherwise not a sensible distance for the frame. In `RANGE`/`GROUPS` framing the offset must be non-negative; a negative or malformed value is rejected.

## When it happens

A window clause like `RANGE BETWEEN -1 PRECEDING AND ...`, a NULL offset expression, or a `GROUPS`/`RANGE` offset whose type or value does not fit the ordering column. It fires per-row when the offset is computed from a column that yields a bad value.

## How to fix

Ensure the frame offset is a non-negative, non-NULL value of a type compatible with the `ORDER BY` column. If the offset comes from a column or expression, guard against negatives and NULLs (for example `COALESCE` and an absolute value, or a `CHECK`). For `RANGE` on numeric/date columns, the offset must be the matching interval/numeric type.

## Example

*Illustrative* — a negative frame offset.

```sql
SELECT sum(x) OVER (ORDER BY x RANGE BETWEEN -1 PRECEDING AND CURRENT ROW) FROM t;
```

Produces:

```text
ERROR:  invalid preceding or following size in window function
```

## Related

- [input is out of range](./input-is-out-of-range.md)
- [invalid value for parameter](./invalid-value-for-parameter-821f2c.md)
