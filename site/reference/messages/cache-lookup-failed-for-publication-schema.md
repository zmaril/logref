---
message: "cache lookup failed for publication schema %u"
slug: cache-lookup-failed-for-publication-schema
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:2978"
  - "postgres/src/backend/commands/publicationcmds.c:1812"
reproduced: false
---

# `cache lookup failed for publication schema %u`

## What it means

Internal error. A publication-schema catalog row (`pg_publication_namespace`) could not be found by OID. The placeholder is the OID. Logical-replication DDL held a reference the cache could not resolve.

## When it happens

A concurrent change to a publication's schema membership while another command still references the row, or catalog inconsistency. Ordinary replication traffic does not raise it.

## How to fix

If publication DDL was running concurrently, retry. If it recurs, inspect `pg_publication_namespace` for the OID; a missing row points to corruption. Report a reproducible case.

## Example

*Illustrative* — a publication schema entry dropped mid-operation.

```text
ERROR:  cache lookup failed for publication schema 16820
```

## Related

- [cannot add schema to publication](./cannot-add-schema-to-publication-d50742.md)
- [cache lookup failed for schema](./cache-lookup-failed-for-schema.md)
