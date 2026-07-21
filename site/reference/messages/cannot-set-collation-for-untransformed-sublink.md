---
message: "cannot set collation for untransformed sublink"
slug: cannot-set-collation-for-untransformed-sublink
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/nodeFuncs.c:1204"
reproduced: false
---

# `cannot set collation for untransformed sublink`

## What it means

An internal guard fired: node-processing code was asked to set the collation of a sub-link expression that has not been transformed. Collation is assigned during parse analysis, so an untransformed sub-link cannot receive one here.

## When it happens

It is reached when internal code walks a parse tree and assigns collation to a `SubLink` node before analysis rewrites it. It reflects a coding issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the query and any extension that manipulates parse trees and report it, since collation should be set only after transformation.

## Example

*Illustrative* — setting collation on an untransformed sub-link.

```text
ERROR:  cannot set collation for untransformed sublink
```

## Related

- [cannot get collation for untransformed sublink](./cannot-get-collation-for-untransformed-sublink.md)
- [cannot set parent params from subquery](./cannot-set-parent-params-from-subquery.md)
