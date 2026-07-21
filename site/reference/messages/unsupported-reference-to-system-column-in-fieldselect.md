---
message: "unsupported reference to system column %d in FieldSelect"
slug: unsupported-reference-to-system-column-in-fieldselect
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execExprInterp.c:3772"
  - "postgres/src/backend/executor/execExprInterp.c:3818"
reproduced: false
---

# `unsupported reference to system column %d in FieldSelect`

## What it means

Internal error. Planner code processing a `FieldSelect` (a reference to a field of a composite value) found it referring to a system column, which is not supported in that context.

## When it happens

It fires where a whole-row or composite reference is decomposed and a system column (such as `ctid` or `xmin`) appears where only user columns are valid. Ordinary queries rarely reach it.

## How to fix

This is an internal guard. Rewriting the query to reference the system column directly rather than through a composite/whole-row value works around it; capture the query and report it if it recurs.

## Example

*Illustrative* — a system column in a FieldSelect.

```text
ERROR:  unsupported reference to system column -1 in FieldSelect
```

## Related

- [unsupported label expression node: %d](./unsupported-label-expression-node.md)
- [unexpected rtekind: %d](./unexpected-rtekind.md)
