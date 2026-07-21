---
message: "negative substring length not allowed"
slug: negative-substring-length-not-allowed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SUBSTRING_ERROR
    code: "22011"
call_sites:
  - "postgres/src/backend/utils/adt/bytea.c:123"
  - "postgres/src/backend/utils/adt/bytea.c:171"
  - "postgres/src/backend/utils/adt/varbit.c:1079"
  - "postgres/src/backend/utils/adt/varbit.c:1189"
  - "postgres/src/backend/utils/adt/varlena.c:610"
  - "postgres/src/backend/utils/adt/varlena.c:674"
  - "postgres/src/backend/utils/adt/varlena.c:869"
reproduced: false
---

# `negative substring length not allowed`

## What it means

A `substring`/`substr` call (on `text`, `bytea`, or bit strings) was given a negative length. Substring length must be zero or positive; a negative value has no meaning and is rejected rather than treated as zero.

## When it happens

`substring(str FROM start FOR length)` or `substr(str, start, length)` where the length expression evaluates to a negative number — often because it is computed (for example `end - start`) and the operands were in the wrong order or out of range.

## How to fix

Ensure the length argument is non-negative. If it is computed, check the arithmetic and guard it (for example `GREATEST(0, end - start)`), or verify the start/end positions. Remember `substring` positions are 1-based; an off-by-one can produce a negative computed length.

## Example

*Illustrative* — a negative computed length.

```sql
SELECT substring('hello' FROM 3 FOR -1);
```

Produces:

```text
ERROR:  negative substring length not allowed
```

## Related

- [input is out of range](./input-is-out-of-range.md)
- [invalid value for parameter](./invalid-value-for-parameter-61fc7e.md)
