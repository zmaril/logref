---
message: "could not find relation mapping for relation \"%s\", OID %u"
slug: could-not-find-relation-mapping-for-relation-oid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack.c:1646"
  - "postgres/src/backend/commands/repack.c:1650"
  - "postgres/src/backend/utils/cache/relcache.c:1395"
reproduced: false
---

# `could not find relation mapping for relation "%s", OID %u`

## What it means

Internal error. Code (here in a repack/rewrite path) could not find the mapping entry for a relation by name and OID. The placeholders are the relation name and OID. The operation expected an internal mapping between old and new relation storage that was missing.

## When it happens

It does not arise from ordinary SQL. It points to an inconsistency in a table-rewrite/repack operation or its internal bookkeeping, rather than to user data.

## How to fix

Treat it as an internal bug in the maintenance operation. Note what you were running (the repack/rewrite command and target), capture logs, and report it. If it recurs on a specific table, avoid the operation on that table until diagnosed.

## Example

*Illustrative* — a missing relation mapping during rewrite.

```text
ERROR:  could not find relation mapping for relation "t", OID 16720
```

## Related

- [could not find tuple for rule](./could-not-find-tuple-for-rule.md)
- [cache lookup failed for partition key of relation](./cache-lookup-failed-for-partition-key-of-relation.md)
