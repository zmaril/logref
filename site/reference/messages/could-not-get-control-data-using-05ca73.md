---
message: "could not get control data using %s: %s"
slug: could-not-get-control-data-using-05ca73
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/controldata.c:173"
  - "postgres/src/bin/pg_upgrade/controldata.c:468"
reproduced: false
---

# `could not get control data using %s: %s`

## What it means

`pg_upgrade` ran `pg_controldata` against a cluster and could not read back its control data. The first `%s` is the command it invoked and the second is the error text it captured. The upgrade cannot proceed without the control values.

## When it happens

The `pg_controldata` binary for that version was missing or unrunnable, the data directory was unreadable, or the tool's output could not be parsed. It fires early in an upgrade while inspecting old and new clusters.

## How to fix

Verify the `--old-bindir`/`--new-bindir` paths point at matching binaries for each cluster and that both data directories are readable by the upgrade user. Run `pg_controldata` on each directory by hand to see the underlying error.

## Example

*Illustrative* — the old-cluster binary path was wrong.

```text
could not get control data using /old/bin/pg_controldata: exit code 1
```

## Related

- [could not get control data using](./could-not-get-control-data-using-ca070c.md)
- [could not rename directory to](./could-not-rename-directory-to.md)
