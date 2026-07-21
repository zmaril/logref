---
message: "arraycontsel called for unrecognized operator %u"
slug: arraycontsel-called-for-unrecognized-operator
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/array_selfuncs.c:493"
reproduced: false
---

# `arraycontsel called for unrecognized operator %u`

## What it means

The array containment selectivity estimator (`arraycontsel`) was asked to estimate selectivity for an operator it does not handle, which should never happen for a correctly configured operator — an internal guard.

## When it happens

It is raised during planning if the array selectivity function is attached to an operator outside the set it supports, normally through a mis-defined operator or a bug.

## How to fix

This is an internal error rather than a user SQL issue. It can indicate a custom operator wrongly pointing its selectivity estimator at `arraycontsel`. If an extension provokes it, report it there; otherwise capture the query and log and report it.

## Example

*Illustrative* — the array selectivity estimator on an unsupported operator.

```text
ERROR:  arraycontsel called for unrecognized operator 12345
```

## Related

- [array_typanalyze was invoked for non-array type](./array-typanalyze-was-invoked-for-non-array-type.md)
- [array size key vs operator mismatch for element ID](./array-size-key-vs-operator-mismatch-for-element-id.md)
