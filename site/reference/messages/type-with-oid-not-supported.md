---
message: "type with oid %u not supported"
slug: type-with-oid-not-supported
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2633"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2669"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2716"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2763"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2844"
reproduced: false
---

# `type with oid %u not supported`

## What it means

Internal error. The jsonpath datetime/value code met a value whose type OID it has no handling for in that context. The placeholder is the OID. It is a switch-default guard over the types the code path is designed to accept.

## When it happens

It should not occur through documented jsonpath usage. Reaching it indicates an internal bug in the SQL/JSON path code, not a problem with your data.

## How to fix

Treat it as an internal bug. If reproducible, capture the jsonpath expression and the JSON/typed input and report it.

## Example

*Illustrative* — emitted internally by the jsonpath code.

```text
ERROR:  type with oid 3802 not supported
```

## Related

- [type with oid does not exist](./type-with-oid-does-not-exist.md)
- [unrecognized SQL/JSON datetime type oid](./unrecognized-sql-json-datetime-type-oid.md)
