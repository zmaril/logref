---
message: "cache lookup failed for publication table %u"
slug: cache-lookup-failed-for-publication-table
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:4267"
  - "postgres/src/backend/catalog/objectaddress.c:6367"
  - "postgres/src/backend/commands/publicationcmds.c:1742"
reproduced: false
---

# `cache lookup failed for publication table %u`

## What it means

Internal error. The catalog row linking a table to a publication (`pg_publication_rel`) could not be found by OID. The placeholder is the OID. Code expected the publication-table membership entry to exist.

## When it happens

A concurrent `ALTER PUBLICATION ... DROP TABLE` or `DROP PUBLICATION`, or catalog inconsistency. Not caused by ordinary data.

## How to fix

If it coincides with concurrent publication DDL, retry. If it recurs for one OID, inspect `pg_publication_rel`; a dangling entry indicates corruption. Report reproducible cases.

## Example

*Illustrative* — a publication-table entry not found.

```text
ERROR:  cache lookup failed for publication table 16800
```

## Related

- [publication does not exist](./publication-does-not-exist.md)
- [cannot use different column lists for table in different publications](./cannot-use-different-column-lists-for-table-in-different-publications.md)
