---
message: "Data type checks failed: %s"
slug: data-type-checks-failed
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/check.c:469"
reproduced: false
---

# `Data type checks failed: %s`

## What it means

`pg_upgrade` found data types in the old cluster that are not safe to carry across the upgrade. The trailing text points at the report of which types and columns are affected. Some type representations change between major versions and block an in-place upgrade.

## When it happens

It happens during `pg_upgrade`'s pre-upgrade checks when the old cluster contains columns of types the target version cannot accept unchanged — for example deprecated or altered on-disk types.

## How to fix

Read the report `pg_upgrade` names for the exact tables and columns. Resolve each — drop or convert the affected columns, or follow the version-specific guidance — then rerun `pg_upgrade`. The check exists so the upgrade does not leave unreadable data behind.

## Example

*Illustrative* — incompatible types blocked the upgrade.

```text
pg_upgrade: error: Data type checks failed: see "data_type_checks.txt"
```

## Related

- [database cluster state problem](./database-cluster-state-problem.md)
- [database user is not the install user](./database-user-is-not-the-install-user.md)
