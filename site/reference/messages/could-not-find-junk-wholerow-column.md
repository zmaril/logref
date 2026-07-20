---
message: "could not find junk wholerow column"
slug: could-not-find-junk-wholerow-column
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeModifyTable.c:5415"
  - "postgres/src/backend/executor/nodeModifyTable.c:5424"
reproduced: false
---

# `could not find junk wholerow column`

## What it means

Internal error. Executor code expected a hidden whole-row junk column in the plan's output and could not find it. The whole-row junk column carries the full row for certain modify or foreign-table operations; its absence is a plan-construction inconsistency.

## When it happens

It should not occur through ordinary SQL. Reaching it points to an internal inconsistency in the modify or foreign-table plan, not to anything in your statement.

## How to fix

Treat it as an internal bug. Capture the statement and its target (view, foreign table, or partitioned table) and report it. Report third-party foreign-data wrappers to their maintainers if one is involved.

## Example

*Illustrative* — emitted internally during a modify.

```text
ERROR:  could not find junk wholerow column
```

## Related

- [could not find junk ctid column](./could-not-find-junk-ctid-column.md)
- [cannot decompile join alias var in plan tree](./cannot-decompile-join-alias-var-in-plan-tree.md)
