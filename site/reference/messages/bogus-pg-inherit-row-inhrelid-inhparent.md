---
message: "bogus pg_inherit row: inhrelid %u inhparent %u"
slug: bogus-pg-inherit-row-inhrelid-inhparent
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:4668"
reproduced: false
---

# `bogus pg_inherit row: inhrelid %u inhparent %u`

## What it means

Reading `pg_inherits`, the server found an inheritance row whose child or parent OID is inconsistent. The placeholders are the child (`inhrelid`) and parent (`inhparent`) OIDs. The row does not describe a valid inheritance link. It signals catalog corruption.

## When it happens

It is raised from inheritance-catalog processing when `pg_inherits` data is damaged. It does not arise from normal DDL.

## How to fix

Treat this as catalog corruption. Examine `pg_inherits` for the named OIDs, and if a link is bad, correcting the inheritance or partition structure may require restoring from backup. Investigate the storage or event that damaged the catalog.

## Example

*Illustrative* — a bad inheritance row.

```text
ERROR:  bogus pg_inherit row: inhrelid 16400 inhparent 16390
```

## Related

- [bogus pg_index tuple](./bogus-pg-index-tuple.md)
- [attribute of relation does not match parent's type](./attribute-of-relation-does-not-match-parent-s-type.md)
