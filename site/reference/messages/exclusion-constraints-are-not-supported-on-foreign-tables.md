---
message: "exclusion constraints are not supported on foreign tables"
slug: exclusion-constraints-are-not-supported-on-foreign-tables
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:1059"
reproduced: false
---

# `exclusion constraints are not supported on foreign tables`

## What it means

A statement tried to define an exclusion constraint on a foreign table. Exclusion constraints rely on a local index and the executor enforcing overlap rules, which foreign tables do not have, so they are not supported there.

## When it happens

It fires from `CREATE FOREIGN TABLE ... EXCLUDE (...)` or `ALTER FOREIGN TABLE ... ADD CONSTRAINT ... EXCLUDE (...)`.

## How to fix

Drop the exclusion constraint from the foreign-table definition. If the rule must be enforced, do it on the remote side (in the source database), or import the data into a regular local table that can carry the exclusion constraint. Foreign tables support only a limited set of constraints, mostly as planner hints.

## Example

*Illustrative* — exclusion constraints are local-only.

```sql
CREATE FOREIGN TABLE ft (a int, EXCLUDE USING gist (a WITH =)) SERVER s;
```

## Related

- [exclusion constraints not possible for domains](./exclusion-constraints-not-possible-for-domains.md)
- [exclusion constraint record missing for rel](./exclusion-constraint-record-missing-for-rel.md)
