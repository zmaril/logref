---
message: "%s cannot be executed from VACUUM or ANALYZE"
slug: cannot-be-executed-from-vacuum-or-analyze
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/vacuum.c:527"
reproduced: false
---

# `%s cannot be executed from VACUUM or ANALYZE`

## What it means

A statement was invoked from code running inside `VACUUM` or `ANALYZE` — typically an index or statistics callback — that is not allowed in that context. Maintenance commands run with restrictions that forbid the attempted operation.

## When it happens

It occurs when a function called during vacuum or analyze, such as an expression-index function or a custom statistics hook, tries to run a disallowed command.

## How to fix

Keep functions used by indexes and statistics free of commands that cannot run under maintenance operations. Move that work out of the code path that vacuum or analyze invokes.

## Example

*Illustrative* — a disallowed command during ANALYZE.

```text
ERROR:  ANALYZE cannot be executed from VACUUM or ANALYZE
```

## Related

- [cannot be executed from a function or procedure](./cannot-be-executed-from-a-function-or-procedure.md)
- [cannot cluster all databases and a specific one at the same time](./cannot-cluster-all-databases-and-a-specific-one-at-the-same-time.md)
