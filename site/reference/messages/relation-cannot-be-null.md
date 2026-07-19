---
message: "relation cannot be null"
slug: relation-cannot-be-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/amcheck/verify_heapam.c:273"
  - "postgres/contrib/pg_prewarm/pg_prewarm.c:81"
reproduced: false
---

# `relation cannot be null`

## What it means

A function or operation that requires a relation argument received null where a relation was expected. The relation reference is mandatory, so a null cannot be accepted.

## When it happens

It arises from calling a system or extension function that takes a relation (a `regclass` or OID) and passing `NULL`, or from a code path that forwarded a null relation reference.

## How to fix

Supply a valid relation. Pass a real table/index reference (for example a `'schema.table'::regclass`) rather than `NULL`, and add a null check before the call if the value can be missing.

## Example

*Illustrative* — a relation-taking function passed NULL.

```text
ERROR:  relation cannot be null
```

## Related

- [relation uses local buffers, %s() is intended to be used for shared buffers only](./relation-uses-local-buffers-is-intended-to-be-used-for-shared-buffers-only.md)
- [tableoid is NULL](./tableoid-is-null.md)
