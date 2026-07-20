---
message: "cache lookup failed for operator with OID %u"
slug: cache-lookup-failed-for-operator-with-oid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/regproc.c:824"
reproduced: false
---

# `cache lookup failed for operator with OID %u`

## What it means

An internal lookup for an operator by OID found no matching `pg_operator` row. The placeholder is the OID. The operator referenced during planning or execution is missing.

## When it happens

It usually reflects a race with a concurrent `DROP OPERATOR`, or catalog inconsistency in `pg_operator`.

## How to fix

Retry if the operator was dropped concurrently. If it persists, investigate catalog consistency and any extension that defines the operator in question.

## Example

*Illustrative* — a missing operator.

```text
ERROR:  cache lookup failed for operator with OID 16412
```

## Related

- [cache lookup failed for procedure with oid](./cache-lookup-failed-for-procedure-with-oid.md)
- [cache lookup failed for oid](./cache-lookup-failed-for-oid.md)
