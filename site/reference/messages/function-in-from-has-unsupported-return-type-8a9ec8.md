---
message: "function in FROM has unsupported return type"
slug: function-in-from-has-unsupported-return-type-8a9ec8
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeFunctionscan.c:423"
  - "postgres/src/backend/parser/parse_relation.c:3041"
  - "postgres/src/backend/utils/fmgr/funcapi.c:1990"
reproduced: false
---

# `function in FROM has unsupported return type`

## What it means

Internal error. A set-returning function used in the `FROM` clause produced a return type the executor's function-scan node does not support. The placeholder-free message is a consistency check: the planner should only place functions with supportable return types in a function scan.

## When it happens

It does not arise from ordinary SQL, which reports clearer type errors during analysis. Reaching this internal form points to a bug, or an unusual function/return-type combination from an extension, rather than to the query text.

## How to fix

Treat it as an internal bug. If a custom or extension function is used in `FROM`, suspect its declared return type; ensure it returns a supported scalar, composite, or `SETOF` type. Capture the query and the function definition and report it.

## Example

*Illustrative* — emitted internally during function-scan setup.

```text
ERROR:  function in FROM has unsupported return type
```

## Related

- [function return row and query-specified return row do not match](./function-return-row-and-query-specified-return-row-do-not-match.md)
- [cannot determine result data type](./cannot-determine-result-data-type.md)
