---
message: "unrecognized GrantStmt.objtype: %d"
slug: unrecognized-grantstmt-objtype
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:531"
  - "postgres/src/backend/catalog/aclchk.c:637"
  - "postgres/src/backend/catalog/aclchk.c:863"
  - "postgres/src/backend/catalog/aclchk.c:1030"
reproduced: false
---

# `unrecognized GrantStmt.objtype: %d`

## What it means

Internal error. Code handling a `GRANT`/`REVOKE` statement encountered an object-type tag in the parsed statement that its switch does not handle. The placeholder is the numeric tag. Every object type the grammar can produce should have a matching case, so an unrecognized one is a `can't happen` guard.

## When it happens

It does not arise from valid SQL. It indicates a bug — a new object type added to the grammar without a corresponding handler, or a corrupted parse tree — rather than anything in the user's command.

## How to fix

Treat it as an internal bug. Capture the exact `GRANT`/`REVOKE` statement and report it. If a non-standard build or extension extends grant handling, suspect that.

## Example

*Illustrative* — emitted internally while processing GRANT.

```text
ERROR:  unrecognized GrantStmt.objtype: 99
```

## Related

- [unrecognized set op](./unrecognized-set-op.md)
- [permission denied to set parameter](./permission-denied-to-set-parameter.md)
