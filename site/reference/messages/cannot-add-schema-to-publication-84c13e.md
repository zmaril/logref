---
message: "cannot add schema to publication \"%s\""
slug: cannot-add-schema-to-publication-84c13e
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/publicationcmds.c:1469"
reproduced: false
---

# `cannot add schema to publication "%s"`

## What it means

A publication could not include a schema through `FOR TABLES IN SCHEMA`. The placeholder is the publication. The named schema cannot be published as a whole, for example because it is a temporary schema or otherwise ineligible.

## When it happens

It occurs in `CREATE PUBLICATION ... FOR TABLES IN SCHEMA` or `ALTER PUBLICATION ... ADD TABLES IN SCHEMA` naming a schema that is not a valid publication target.

## How to fix

Publish an eligible, regular schema, or list specific tables with `FOR TABLE` instead of whole-schema publication. Temporary and system schemas cannot be added as schema publications.

## Example

*Illustrative* — publishing an ineligible schema.

```sql
ALTER PUBLICATION p ADD TABLES IN SCHEMA pg_temp;
```

## Related

- [cannot add schema to extension because the schema contains the extension](./cannot-add-schema-to-extension-because-the-schema-contains-the-extension.md)
- [cannot alter two_phase when logical replication worker is still running](./cannot-alter-two-phase-when-logical-replication-worker-is-still-running.md)
