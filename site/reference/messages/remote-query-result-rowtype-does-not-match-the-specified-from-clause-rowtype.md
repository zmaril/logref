---
message: "remote query result rowtype does not match the specified FROM clause rowtype"
slug: remote-query-result-rowtype-does-not-match-the-specified-from-clause-rowtype
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/contrib/dblink/dblink.c:926"
  - "postgres/contrib/dblink/dblink.c:1215"
reproduced: false
---

# `remote query result rowtype does not match the specified FROM clause rowtype`

## What it means

A `dblink` (or similar remote query) returned rows whose column types do not match the row type declared in the local `AS (...)` clause. The caller told Postgres to expect one shape, and the remote result had another.

## When it happens

It arises with `dblink('...', 'SELECT ...') AS t(col type, ...)` when the declared column list disagrees with the actual result — wrong number of columns, or incompatible types.

## How to fix

Make the `AS (...)` column definition list exactly match the remote query's output columns and types, in order. If the remote schema changed, update the local declaration to follow it.

## Example

*Illustrative* — a dblink result not matching the declared row type.

```text
ERROR:  remote query result rowtype does not match the specified FROM clause rowtype
```

## Related

- [record type has not been registered](./record-type-has-not-been-registered.md)
- [return type of transition function %s is not %s](./return-type-of-transition-function-is-not.md)
