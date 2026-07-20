---
message: "could not convert row type"
slug: could-not-convert-row-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/access/common/attmap.c:229"
  - "postgres/src/backend/access/common/attmap.c:241"
reproduced: false
---

# `could not convert row type`

## What it means

Internal error. Row-conversion code (mapping a tuple from one composite/row type to another, for example across an inheritance or type change) could not produce the target shape. It is a consistency check on the attribute mapping between the two row types.

## When it happens

It should not occur through ordinary SQL. Reaching it points to an internal inconsistency between the source and target row descriptors, not to anything in your data itself.

## How to fix

Treat it as an internal bug. Capture the query and the tables or types involved (especially any recent `ALTER TABLE` or inheritance change) and report it. If a specific schema change preceded it, note that in the report.

## Example

*Illustrative* — emitted internally during row conversion.

```text
ERROR:  could not convert row type
```

## Related

- [cached plan must not change result type](./cached-plan-must-not-change-result-type.md)
- [cannot alter type because column uses it](./cannot-alter-type-because-column-uses-it.md)
