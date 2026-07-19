---
message: "%d: database cluster state problem"
slug: database-cluster-state-problem
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/controldata.c:137"
reproduced: false
---

# `%d: database cluster state problem`

## What it means

`pg_upgrade` read the old or new cluster's control data and found the cluster in a state it will not upgrade from. The leading placeholder is a code identifying the state. A cluster must be shut down cleanly and consistent before an upgrade.

## When it happens

It happens during `pg_upgrade`'s checks when a cluster's recorded state is not a clean shutdown — for example it was interrupted, is in recovery, or was left in an in-progress state.

## How to fix

Bring the cluster to a clean shutdown before upgrading. Start it normally, let it finish any recovery, then stop it with a clean shutdown (`pg_ctl stop -m fast`). Confirm the state with `pg_controldata`, which should report the cluster as shut down, and rerun `pg_upgrade`.

## Example

*Illustrative* — a cluster not cleanly shut down.

```text
pg_upgrade: error: 8: database cluster state problem
```

## Related

- [database cluster is not compatible](./database-cluster-is-not-compatible.md)
- [database server was not shut down cleanly](./database-server-was-not-shut-down-cleanly.md)
