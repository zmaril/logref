---
message: "cannot apply ResourceOwner to non-saved cached plan"
slug: cannot-apply-resourceowner-to-non-saved-cached-plan
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/plancache.c:1310"
reproduced: false
---

# `cannot apply ResourceOwner to non-saved cached plan`

## What it means

An internal guard in the plan cache: code asked to attach a resource owner to a cached plan that was not marked as saved. Only saved plans are reference-counted through a resource owner, so applying one to a transient plan is a programming error.

## When it happens

It is a can't-happen consistency check in `plancache.c`. It would only surface from a bug in code that manages cached plans, such as an extension or a PL handler.

## How to fix

There is no user-level fix in SQL. If it appears, capture the statement and the extensions in use and report it, since it points to incorrect plan-cache handling rather than a data problem.

## Example

*Illustrative* — the internal plan-cache guard.

```text
ERROR:  cannot apply ResourceOwner to non-saved cached plan
```

## Related

- [cannot change relation mapping in parallel mode](./cannot-change-relation-mapping-in-parallel-mode.md)
- [cannot assign new oid to existing shell type](./cannot-assign-new-oid-to-existing-shell-type.md)
