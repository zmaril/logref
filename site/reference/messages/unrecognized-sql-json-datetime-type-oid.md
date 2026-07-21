---
message: "unrecognized SQL/JSON datetime type oid: %u"
slug: unrecognized-sql-json-datetime-type-oid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:4079"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:4105"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:4131"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:4160"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:4189"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:4195"
reproduced: false
---

# `unrecognized SQL/JSON datetime type oid: %u`

## What it means

Internal error. The SQL/JSON datetime code mapped a datetime value to a known type OID (date, time, timestamp, and their timezone variants) and reached an OID it does not handle. The placeholder is the OID. It is a switch-default guard over a fixed set of built-in types.

## When it happens

It should not occur for standard datetime handling inside jsonpath. Reaching it indicates an internal bug in the SQL/JSON datetime path.

## How to fix

Treat it as an internal bug. If reproducible, capture the jsonpath datetime expression and input and report it.

## Example

*Illustrative* — emitted internally by the SQL/JSON datetime code.

```text
ERROR:  unrecognized SQL/JSON datetime type oid: 1184
```

## Related

- [unrecognized jsonpath item type](./unrecognized-jsonpath-item-type.md)
- [type with oid not supported](./type-with-oid-not-supported.md)
