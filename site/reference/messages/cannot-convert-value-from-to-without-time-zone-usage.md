---
message: "cannot convert value from %s to %s without time zone usage"
slug: cannot-convert-value-from-to-without-time-zone-usage
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:3992"
reproduced: false
---

# `cannot convert value from %s to %s without time zone usage`

## What it means

An XML or SQL/XML datatype conversion between date/time types would require applying the session time zone, but the operation was told not to use it. The placeholders are the source and target types. The conversion cannot be done without consulting a time zone, which the strict mode forbids.

## When it happens

It occurs in XML export or `xmltable` processing when converting between time-zone-aware and time-zone-naive temporal types under a mode that disallows implicit time-zone use.

## How to fix

Convert between temporal types that do not require a time-zone shift, or perform the time-zone conversion explicitly before the XML operation. Align the source and target types so no implicit time-zone application is needed.

## Example

*Illustrative* — a time-zone-dependent conversion.

```text
ERROR:  cannot convert value from timestamp to timestamptz without time zone usage
```

## Related

- [cannot convert infinity to](./cannot-convert-infinity-to.md)
- [cannot cast xmlserialize result to](./cannot-cast-xmlserialize-result-to.md)
