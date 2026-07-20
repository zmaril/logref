---
message: "Cannot upgrade to/from the same system catalog version when\nusing tablespaces."
slug: cannot-upgrade-to-from-the-same-system-catalog-version-when-using-tablespaces
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/tablespace.c:36"
reproduced: false
---

# `Cannot upgrade to/from the same system catalog version when
using tablespaces.`

## What it means

`pg_upgrade` found that the old and new clusters share the same catalog version while user tablespaces are in play. In-place upgrade relies on the two clusters differing so their tablespace directories do not collide, so this combination is refused.

## When it happens

It occurs during `pg_upgrade` between builds that report the same catalog version, for example two builds of the same major version, when the cluster has non-default tablespaces.

## How to fix

Upgrade between clusters whose catalog versions differ, or move off user tablespaces for the upgrade. For same-version moves, use dump and restore instead of `pg_upgrade`.

## Example

*Illustrative* — same catalog version with tablespaces.

```text
pg_upgrade: fatal: Cannot upgrade to/from the same system catalog version when using tablespaces.
```

## Related

- [cannot use multiple jobs to reindex system catalogs](./cannot-use-multiple-jobs-to-reindex-system-catalogs.md)
- [cannot specify both --single-transaction and multiple jobs](./cannot-specify-both-single-transaction-and-multiple-jobs.md)
