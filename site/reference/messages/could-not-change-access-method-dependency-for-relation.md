---
message: "could not change access method dependency for relation \"%s.%s\""
slug: could-not-change-access-method-dependency-for-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack.c:1763"
  - "postgres/src/backend/commands/repack.c:1771"
reproduced: false
---

# `could not change access method dependency for relation "%s.%s"`

## What it means

Internal error. During a `REPACK` (or similar rebuild), catalog code failed to update the dependency linking a relation to its access method. The placeholder is the qualified relation. It is a catalog-maintenance step that did not complete as expected.

## When it happens

It should not occur in normal operation. Reaching it points to an internal inconsistency in dependency bookkeeping during a rebuild, not to anything in your data.

## How to fix

Treat it as an internal error. Preserve the server log and the relation involved, and report it. If a specific table reproduces it, inspect its `pg_depend` entries for the access method; an anomaly there suggests catalog damage worth restoring from backup.

## Example

*Illustrative* — emitted internally during a repack.

```text
ERROR:  could not change access method dependency for relation "public.orders"
```

## Related

- [could not apply concurrent on relation](./could-not-apply-concurrent-on-relation.md)
- [could not find target tuple](./could-not-find-target-tuple.md)
