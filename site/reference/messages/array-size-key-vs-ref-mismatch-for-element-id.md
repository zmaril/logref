---
message: "array size key (%d) vs ref (%d) mismatch for element ID %u"
slug: array-size-key-vs-ref-mismatch-for-element-id
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/rewrite/rewriteGraphTable.c:1195"
reproduced: false
---

# `array size key (%d) vs ref (%d) mismatch for element ID %u`

## What it means

Internal bookkeeping found that the number of array-size keys did not match the number of references recorded for an element, an internal consistency guard over that structure.

## When it happens

It is raised in the same support code as the operator-count variant when the key and reference counts for an element disagree, normally only reachable through a bug or corrupted data.

## How to fix

This is an internal error, not something to rewrite in SQL. If it recurs, capture the log and any custom operator classes or extensions involved and report it. There is no user-level workaround.

## Example

*Illustrative* — a key-versus-ref count mismatch.

```text
ERROR:  array size key (3) vs ref (2) mismatch for element ID 42
```

## Related

- [array size key vs operator mismatch for element ID](./array-size-key-vs-operator-mismatch-for-element-id.md)
- [arraycontsel called for unrecognized operator](./arraycontsel-called-for-unrecognized-operator.md)
