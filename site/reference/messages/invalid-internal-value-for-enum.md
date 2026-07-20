---
message: "invalid internal value for enum: %u"
slug: invalid-internal-value-for-enum
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_BINARY_REPRESENTATION
    code: "22P03"
call_sites:
  - "postgres/src/backend/utils/adt/enum.c:164"
  - "postgres/src/backend/utils/adt/enum.c:230"
  - "postgres/src/backend/utils/adt/enum.c:289"
reproduced: false
---

# `invalid internal value for enum: %u`

## What it means

Internal error. An enum value was read whose stored object identifier does not correspond to any label of the enum type. Enum values are stored as identifiers pointing at catalog rows, and this one pointed at nothing valid.

## When it happens

It should not occur when reading consistent data. Reaching it points to a value written by a since-dropped or altered enum, on-disk corruption, or catalog inconsistency, rather than to normal query activity.

## How to fix

Treat it as a data or catalog integrity problem. Identify the table and column, check whether enum labels were dropped or the type was recreated, and restore affected rows from a backup if the stored identifiers no longer map to labels.

## Example

*Illustrative* — a stored enum identifier with no matching label.

```text
ERROR:  invalid internal value for enum: 16543
```

## Related

- [invalid enum label](./invalid-enum-label.md)
- [invalid compression method id](./invalid-compression-method-id.md)
