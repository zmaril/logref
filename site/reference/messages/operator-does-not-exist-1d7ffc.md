---
message: "operator %u does not exist"
slug: operator-does-not-exist-1d7ffc
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/lsyscache.c:1796"
  - "postgres/src/backend/utils/cache/lsyscache.c:1812"
reproduced: false
---

# `operator %u does not exist`

## What it means

Internal error. Code resolved an operator by OID and found no matching `pg_operator` row. The placeholder is the operator OID. This is the OID-lookup form, distinct from the query-time 'operator does not exist: name' a type mismatch produces.

## When it happens

It fires when an internal reference holds an operator OID that no longer resolves — typically concurrent DDL dropping the operator, or catalog inconsistency. Ordinary queries surface the by-name form instead.

## How to fix

This is a can't-happen guard. If it coincides with concurrent DDL on operators, retry. If it recurs, inspect `pg_operator` for the OID and report a reproducible case; a missing expected row points to catalog damage.

## Example

*Illustrative* — an operator OID that does not resolve.

```text
ERROR:  operator 16610 does not exist
```

## Related

- [missing oprcode for operator](./missing-oprcode-for-operator.md)
- [operator cannot be its own negator](./operator-cannot-be-its-own-negator.md)
