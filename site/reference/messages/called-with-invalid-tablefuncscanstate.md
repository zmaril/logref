---
message: "%s called with invalid TableFuncScanState"
slug: called-with-invalid-tablefuncscanstate
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:4413"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:4416"
  - "postgres/src/backend/utils/adt/xml.c:4714"
  - "postgres/src/backend/utils/adt/xml.c:4717"
reproduced: false
---

# `%s called with invalid TableFuncScanState`

## What it means

Internal error. A table-function (here jsonpath/`JSON_TABLE`/`XMLTABLE` support) routine was invoked with an execution state that is not the expected `TableFuncScanState`. The placeholder is the function name. It is a consistency check on the executor node state passed to the routine.

## When it happens

It should not occur through normal SQL. Reaching it indicates an internal bug in the table-function executor path, not a problem with your query.

## How to fix

Treat it as an internal bug. If reproducible, capture the `JSON_TABLE`/`XMLTABLE` statement and report it.

## Example

*Illustrative* — emitted internally by the table-function code.

```text
ERROR:  JsonTableInitOpaque called with invalid TableFuncScanState
```

## Related

- [unrecognized result from subplan](./unrecognized-result-from-subplan.md)
- [invalid tuplestore state](./invalid-tuplestore-state.md)
