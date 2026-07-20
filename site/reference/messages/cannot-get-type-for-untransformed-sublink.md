---
message: "cannot get type for untransformed sublink"
slug: cannot-get-type-for-untransformed-sublink
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/nodeFuncs.c:108"
  - "postgres/src/backend/nodes/nodeFuncs.c:353"
reproduced: false
---

# `cannot get type for untransformed sublink`

## What it means

Internal error. Expression-type code was asked for the result type of a sublink (subquery expression) that has not yet been through parse analysis. A raw, untransformed sublink has no resolved type, so the request is premature.

## When it happens

It should not occur through ordinary SQL. Reaching it points to an internal ordering problem in parse analysis, not to anything in your query text.

## How to fix

Treat it as an internal bug. Capture the query containing the subquery expression and report it. There is no query-side change expected to avoid it, though simplifying the offending subquery may sidestep the code path while a fix is pending.

## Example

*Illustrative* — emitted internally during parse analysis.

```text
ERROR:  cannot get type for untransformed sublink
```

## Related

- [cannot decompile join alias var in plan tree](./cannot-decompile-join-alias-var-in-plan-tree.md)
- [could not determine data type of parameter](./could-not-determine-data-type-of-parameter.md)
