---
message: "could not open relation with OID %u"
slug: could-not-open-relation-with-oid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/common/relation.c:62"
  - "postgres/src/backend/access/common/relation.c:116"
  - "postgres/src/backend/replication/logical/reorderbuffer.c:2492"
  - "postgres/src/backend/utils/cache/relcache.c:5615"
reproduced: true
---

# `could not open relation with OID %u`

## What it means

Internal error. Low-level code tried to open a relation by OID and found no such relation. The placeholder is the OID. Callers at this level expect the relation to exist; a missing one usually means it was dropped out from under the operation or the catalog is inconsistent.

## When it happens

Typically a concurrent `DROP`/`TRUNCATE`-with-rewrite of the relation while another operation holds an OID reference to it; otherwise catalog inconsistency. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL, retry — the relation was dropped. If it recurs without concurrent drops, inspect the referencing object and the catalog; a persistently missing relation indicates corruption warranting investigation.

## Example

*Reproduced* — captured from `reproducers/scenarios/42_contrib_inspection.sql`.

```sql
SELECT bt_index_check(999999999);
```

Produces:

```text
ERROR:  could not open relation with OID 999999999
```

## Related

- [cache lookup failed for %s %u](./cache-lookup-failed-for.md)
- [could not find tuple for trigger](./could-not-find-tuple-for-trigger.md)
