---
message: "executor could not find named tuplestore \"%s\""
slug: executor-could-not-find-named-tuplestore
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeNamedtuplestorescan.c:107"
reproduced: false
---

# `executor could not find named tuplestore "%s"`

## What it means

An internal executor guard. A plan referenced a named tuplestore — the in-memory result set behind a transition table or an ephemeral named relation — and it was not registered under that name at run time. The placeholder is the name.

## When it happens

It fires when a trigger's `REFERENCING OLD/NEW TABLE` transition table, or a similar named ephemeral relation, is expected by the plan but was not set up by the calling code. In normal operation the executor registers these before running the plan.

## How to fix

This is an internal invariant, not a query-author setting. It usually points at a mismatch between a trigger definition and how it is invoked, or an extension driving the executor directly. Capture the trigger or function definition and the statement, and report it if the setup was standard.

## Example

*Illustrative* — the message as logged.

```
ERROR:  executor could not find named tuplestore "new_rows"
```

## Related

- [ExecReScanModifyTable is not implemented](./execrescanmodifytable-is-not-implemented.md)
- [expandTableLikeClause called on untransformed LIKE clause](./expandtablelikeclause-called-on-untransformed-like-clause.md)
