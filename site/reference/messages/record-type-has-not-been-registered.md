---
message: "record type has not been registered"
slug: record-type-has-not-been-registered
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/utils/cache/typcache.c:1926"
  - "postgres/src/backend/utils/fmgr/funcapi.c:574"
reproduced: false
---

# `record type has not been registered`

## What it means

Code tried to look up the row definition for an anonymous `record` type using a type modifier that was never registered in this session. Anonymous composite types are assigned a transient id that must be registered before it can be resolved.

## When it happens

It arises when handling `record` values whose structure is only known at run time — for example returning `record` from a function without a column definition list, or passing anonymous rows across a boundary that loses the registration.

## How to fix

Give the record a concrete shape the server can resolve: provide a column definition list (`AS (col type, ...)`) at the call site, declare a named composite type, or use `OUT` parameters so the row type is known. Avoid passing bare `record` values where the definition is not available.

## Example

*Illustrative* — using an anonymous record whose type was not registered.

```text
ERROR:  record type has not been registered
```

## Related

- [type %u does not match constructor type](./type-does-not-match-constructor-type.md)
- [remote query result rowtype does not match the specified FROM clause rowtype](./remote-query-result-rowtype-does-not-match-the-specified-from-clause-rowtype.md)
