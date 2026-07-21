---
message: "unrecognized operator: %d"
slug: unrecognized-operator
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/intarray/_int_selfuncs.c:323"
  - "postgres/src/backend/tsearch/ts_selfuncs.c:420"
  - "postgres/src/backend/utils/adt/tsvector_op.c:1811"
  - "postgres/src/backend/utils/adt/tsvector_op.c:1943"
  - "postgres/src/backend/utils/adt/tsvector_op.c:2114"
  - "postgres/src/backend/utils/adt/tsvector_op.c:2169"
reproduced: false
---

# `unrecognized operator: %d`

## What it means

Internal error. The `intarray` extension's selectivity code mapped a query operator to an internal strategy and reached one it does not handle. The placeholder is the numeric operator. It is a switch-default guard in code that should only ever see the extension's own operators.

## When it happens

It should not occur through the extension's documented operators. Reaching it suggests a mismatch between the `intarray` shared library and its SQL definitions, or a bug.

## How to fix

Treat it as an internal bug. Confirm the `intarray` extension's SQL and shared library are from the same version (a fresh `ALTER EXTENSION intarray UPDATE` after a binary upgrade). If it persists, report it.

## Example

*Illustrative* — emitted internally by intarray.

```text
ERROR:  unrecognized operator: 99
```

## Related

- [operator is not a valid ordering operator](./operator-is-not-a-valid-ordering-operator-d60acf.md)
- [unrecognized result from subplan](./unrecognized-result-from-subplan.md)
