---
message: "control file appears to be corrupt"
slug: control-file-appears-to-be-corrupt-a3a6c0
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:691"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:721"
reproduced: false
---

# `control file appears to be corrupt`

## What it means

The `pg_createsubscriber` tool read a cluster's control file and found it inconsistent — a bad CRC or unexpected contents. The placeholder context is the control file. The tool cannot trust cluster metadata it cannot verify.

## When it happens

Running `pg_createsubscriber` against a data directory whose `pg_control` file is damaged, truncated, from an incompatible version, or being read while the cluster is in an unexpected state.

## How to fix

Verify you pointed the tool at the correct, intact data directory and that the cluster was shut down cleanly. If the control file is genuinely damaged, the cluster needs recovery or restoration from backup before it can be used as a subscriber source. Check for version mismatches between the tool and the cluster.

## Example

*Illustrative* — a damaged control file during setup.

```text
pg_createsubscriber: error: control file appears to be corrupt
```

## Related

- [could not determine parameter settings on new cluster](./could-not-determine-parameter-settings-on-new-cluster.md)
- [could not find redo location referenced by checkpoint record at](./could-not-find-redo-location-referenced-by-checkpoint-record-at.md)
