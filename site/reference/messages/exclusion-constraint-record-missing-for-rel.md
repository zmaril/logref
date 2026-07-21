---
message: "exclusion constraint record missing for rel %s"
slug: exclusion-constraint-record-missing-for-rel
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/relcache.c:5759"
reproduced: false
---

# `exclusion constraint record missing for rel %s`

## What it means

An internal consistency check in the relation cache. An index was marked as backing an exclusion constraint, but the matching `pg_constraint` record could not be found. The placeholder names the relation.

## When it happens

It fires while the server builds cached constraint information for a relation and the exclusion-constraint metadata is inconsistent between the index and the constraint catalog. In a healthy database this cannot happen.

## How to fix

This points at catalog inconsistency rather than a user mistake. Check for a recent crash, interrupted DDL, or storage problems on the catalog. `REINDEX` of the affected index and, if the inconsistency persists, restoring the table from a known-good dump may be needed. Capture the details and report it if the catalog was not manually altered.

## Example

*Illustrative* — the message as logged.

```
ERROR:  exclusion constraint record missing for rel orders
```

## Related

- [exclusion constraints are not supported on foreign tables](./exclusion-constraints-are-not-supported-on-foreign-tables.md)
- [exclusion constraints not possible for domains](./exclusion-constraints-not-possible-for-domains.md)
