---
message: "array size key (%d) vs operator (%d) mismatch for element ID %u"
slug: array-size-key-vs-operator-mismatch-for-element-id
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/rewrite/rewriteGraphTable.c:1197"
reproduced: false
---

# `array size key (%d) vs operator (%d) mismatch for element ID %u`

## What it means

Internal statistics or index-support bookkeeping found that the number of array-size keys did not match the number of operators recorded for an element, an internal consistency guard over that structure.

## When it happens

It is raised deep in support code (for example operator-class or statistics handling) when two counts that must agree for an element do not, normally only reachable through a bug or corrupted catalog data.

## How to fix

This is an internal error rather than a user SQL fault. If it appears, capture the surrounding log and any extensions or custom operator classes involved and report it. There is no query-level workaround.

## Example

*Illustrative* — a key-versus-operator count mismatch.

```text
ERROR:  array size key (3) vs operator (2) mismatch for element ID 42
```

## Related

- [array size key vs ref mismatch for element ID](./array-size-key-vs-ref-mismatch-for-element-id.md)
- [arraycontsel called for unrecognized operator](./arraycontsel-called-for-unrecognized-operator.md)
