---
message: "attribute %d has wrong type"
slug: attribute-has-wrong-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/executor/execExprInterp.c:3789"
  - "postgres/src/backend/executor/execExprInterp.c:3835"
reproduced: false
---

# `attribute %d has wrong type`

## What it means

Internal error. Expression evaluation found that a column it read has a different type than the plan expected. The message names the attribute number. It is a consistency check that guards against a mismatch between a cached plan and the current table shape.

## When it happens

It can surface when a table's column types changed underneath a cached plan or a stored expression, or from an internal inconsistency. It should not arise from a single self-consistent query.

## How to fix

If it followed a schema change, discard cached plans by reconnecting or re-preparing statements, since a plan built against the old column types no longer matches. If it recurs without any schema change, capture the query and report it as an internal issue.

## Example

*Illustrative* — a column type not matching the plan.

```text
ERROR:  attribute 2 has wrong type
```

## Related

- [a null isnull pointer was passed](./a-null-isnull-pointer-was-passed.md)
- [attribute of relation with oid does not exist](./attribute-of-relation-with-oid-does-not-exist.md)
