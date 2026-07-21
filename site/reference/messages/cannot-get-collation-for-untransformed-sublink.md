---
message: "cannot get collation for untransformed sublink"
slug: cannot-get-collation-for-untransformed-sublink
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/nodeFuncs.c:894"
reproduced: false
---

# `cannot get collation for untransformed sublink`

## What it means

An internal guard fired: the node-processing code was asked for the collation of a sub-link expression that has not yet been transformed. Collation is assigned during parse analysis, so an untransformed sub-link has none to report.

## When it happens

It is reached when internal code walks a parse tree and requests collation on a `SubLink` node before analysis has rewritten it into its final form. It reflects a coding issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the query and any extension that inspects parse trees and report it, since collation should only be requested after transformation.

## Example

*Illustrative* — collation requested on an untransformed sub-link.

```text
ERROR:  cannot get collation for untransformed sublink
```

## Related

- [cannot handle unplanned sub-select](./cannot-handle-unplanned-sub-select.md)
- [cannot handle qualified ON SELECT rule](./cannot-handle-qualified-on-select-rule.md)
