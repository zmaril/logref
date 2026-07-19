---
message: "unrecognized jsonpath item type: %d"
slug: unrecognized-jsonpath-item-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath.c:470"
  - "postgres/src/backend/utils/adt/jsonpath.c:897"
  - "postgres/src/backend/utils/adt/jsonpath.c:996"
  - "postgres/src/backend/utils/adt/jsonpath.c:1162"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1698"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2874"
reproduced: false
---

# `unrecognized jsonpath item type: %d`

## What it means

Internal error. The jsonpath executor switches over the node types that make up a compiled jsonpath expression and reached one it has no case for. The placeholder is the numeric item type. Because jsonpath items are a closed set produced by the parser, an unknown type means a malformed compiled expression or a bug.

## When it happens

It should not occur from a jsonpath that parsed successfully. Reaching it indicates an internal bug in the jsonpath compiler or executor.

## How to fix

Treat it as an internal bug. If reproducible, capture the exact jsonpath expression and the JSON input and report it.

## Example

*Illustrative* — emitted internally by the jsonpath executor.

```text
ERROR:  unrecognized jsonpath item type: 42
```

## Related

- [unrecognized SQL/JSON datetime type oid](./unrecognized-sql-json-datetime-type-oid.md)
- [type with oid not supported](./type-with-oid-not-supported.md)
