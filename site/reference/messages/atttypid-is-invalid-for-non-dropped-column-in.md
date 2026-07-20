---
message: "atttypid is invalid for non-dropped column in \"%s\""
slug: atttypid-is-invalid-for-non-dropped-column-in
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parse_relation.c:2660"
reproduced: false
---

# `atttypid is invalid for non-dropped column in "%s"`

## What it means

While reading a relation's column catalog, the server found a column marked as live whose type OID is invalid (zero). Only dropped columns are allowed to carry an invalid type OID, so a live column with one signals catalog corruption. The placeholder is the relation.

## When it happens

It is raised from tuple-descriptor construction when `pg_attribute` rows are inconsistent. It does not arise from normal SQL.

## How to fix

This points at damaged catalog data rather than a query mistake. Investigate `pg_attribute` for the named relation, check hardware and storage, restore from a known-good backup if the catalog is corrupt, and report the finding with the relation's catalog state.

## Example

*Illustrative* — the catalog check firing on a relation.

```text
ERROR:  atttypid is invalid for non-dropped column in "orders"
```

## Related

- [attribute of type has been dropped](./attribute-of-type-has-been-dropped.md)
- [bogus pg_index tuple](./bogus-pg-index-tuple.md)
