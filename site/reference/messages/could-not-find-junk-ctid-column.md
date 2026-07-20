---
message: "could not find junk ctid column"
slug: could-not-find-junk-ctid-column
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:4248"
  - "postgres/src/backend/executor/nodeModifyTable.c:5394"
reproduced: false
---

# `could not find junk ctid column`

## What it means

Internal error. Executor code for an update, delete, or foreign-table modify expected a hidden `ctid` junk column in the plan's output and could not find it. The junk `ctid` identifies the row to modify; its absence is a plan-construction inconsistency.

## When it happens

It should not occur through ordinary SQL. Reaching it points to an internal inconsistency in how the modify plan was built, not to anything in your statement.

## How to fix

Treat it as an internal bug. Capture the modifying statement (including any foreign-table or view target) and report it. For third-party foreign-data wrappers, report it to the wrapper if it participates in the plan.

## Example

*Illustrative* — emitted internally during a modify.

```text
ERROR:  could not find junk ctid column
```

## Related

- [could not find junk wholerow column](./could-not-find-junk-wholerow-column.md)
- [could not find target tuple](./could-not-find-target-tuple.md)
