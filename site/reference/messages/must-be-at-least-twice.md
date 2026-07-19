---
message: "\"%s\" must be at least twice \"%s\""
slug: must-be-at-least-twice
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:4610"
  - "postgres/src/backend/access/transam/xlog.c:4616"
reproduced: false
---

# `"%s" must be at least twice "%s"`

## What it means

One configured value must be at least twice another, and the given value is too small relative to it. The placeholders name the two settings. Some settings have this proportional requirement.

## When it happens

It arises when setting related sizing parameters where one must be a multiple of the other — for example a buffer or limit that must be at least double a dependent size — and the values violate that ratio.

## How to fix

Increase the first value to at least twice the second, or decrease the second so the ratio holds. Read the documentation for the two named settings to confirm the required relationship, then set both consistently.

## Example

*Illustrative* — a value below the required 2x floor.

```text
ERROR:  "max_wal_size" must be at least twice "wal_segment_size"
```

## Related

- [must be >= 0](./must-be-0.md)
- [must be in range](./must-be-in-range-979b1e.md)
