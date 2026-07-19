---
message: "could not find tuple for rule %u"
slug: could-not-find-tuple-for-rule
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:3486"
  - "postgres/src/backend/catalog/objectaddress.c:5612"
  - "postgres/src/backend/rewrite/rewriteRemove.c:61"
reproduced: false
---

# `could not find tuple for rule %u`

## What it means

Internal error. Code looked up a rewrite rule in `pg_rewrite` by OID and found no row. The placeholder is the rule OID. A rule the catalog still referenced was expected to exist and did not.

## When it happens

A concurrent drop of the rule or its owning object, or catalog inconsistency. Not driven by ordinary data.

## How to fix

If it coincides with concurrent DDL on rules/views, retry. If it recurs for one OID, inspect `pg_rewrite`; a dangling reference indicates corruption. Recreating the owning view/rule rewrites the entries. Report reproducible cases.

## Example

*Illustrative* — a rewrite-rule row not found.

```text
ERROR:  could not find tuple for rule 16750
```

## Related

- [could not find tuple for attrdef](./could-not-find-tuple-for-attrdef.md)
- [unrecognized token](./unrecognized-token.md)
