---
message: "cannot cluster all databases and a specific one at the same time"
slug: cannot-cluster-all-databases-and-a-specific-one-at-the-same-time
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/scripts/clusterdb.c:148"
reproduced: true
---

# `cannot cluster all databases and a specific one at the same time`

## What it means

The `clusterdb` tool was given both `--all` and a specific database name. Those options are mutually exclusive: either cluster every database or cluster one named database, not both.

## When it happens

It occurs when invoking `clusterdb --all` together with a database name argument or `--dbname`.

## How to fix

Choose one mode. Use `clusterdb --all` to cluster all databases, or `clusterdb dbname` to cluster a single database, but do not combine them.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__69_scripts`); see the reproducer for the triggering workload. It emits:

```text
FATAL:  cannot cluster all databases and a specific one at the same time
```

## Related

- [cannot cluster on partial index](./cannot-cluster-on-partial-index.md)
- [cannot be run as root (initdb)](./cannot-be-run-as-root-0ebb85.md)
