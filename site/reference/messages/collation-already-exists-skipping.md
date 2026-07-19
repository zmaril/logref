---
message: "collation \"%s\" already exists, skipping"
slug: collation-already-exists-skipping
passthrough: false
api: [ereport]
level: [NOTICE]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/catalog/pg_collation.c:98"
  - "postgres/src/backend/catalog/pg_collation.c:157"
reproduced: false
---

# `collation "%s" already exists, skipping`

## What it means

A notice that a collation being created already exists, so the creation was skipped rather than raising an error.

## When it happens

It arises from `CREATE COLLATION IF NOT EXISTS`, and from `pg_import_system_collations`, when a collation of that name is already present.

## Is this a problem?

No action is needed. The `IF NOT EXISTS` (or import) path intentionally skips existing collations and reports it as a notice. It confirms the collation is present.

## Example

*Illustrative* — skipping an existing collation.

```text
NOTICE:  collation "en_US" already exists, skipping
```

## Related

- [publication parameters are not applicable to sequence synchronization and will be ignored for sequences](./publication-parameters-are-not-applicable-to-sequence-synchronization-and-will.md)
- [operator family "%s" of access method %s is missing cross-type operator(s)](./operator-family-of-access-method-is-missing-cross-type-operator-s.md)
