---
message: "could not change support dependency for function %s"
slug: could-not-change-support-dependency-for-function
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1473"
reproduced: false
---

# `could not change support dependency for function %s`

## What it means

An internal step that updates a function's support dependency (linking it to a support function or planner support) could not find or update the expected `pg_depend` record. This is a catalog-consistency check.

## When it happens

It fires during function DDL that adjusts support dependencies when the expected dependency entry is missing or in an unexpected state.

## How to fix

This is an internal error that can indicate catalog inconsistency. Note the function and operation, inspect its dependencies, and report it if it recurs on a healthy catalog. Avoid manual edits to `pg_depend`.

## Example

*Illustrative* — a failed function support-dependency update.

```text
ERROR:  could not change support dependency for function myfunc(integer)
```

## Related

- [could not change schema dependency for type](./could-not-change-schema-dependency-for-type.md)
- [could not change schema dependency for object](./could-not-change-schema-dependency-for-object.md)
