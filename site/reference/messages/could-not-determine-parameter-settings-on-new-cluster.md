---
message: "could not determine parameter settings on new cluster"
slug: could-not-determine-parameter-settings-on-new-cluster
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/check.c:2123"
  - "postgres/src/bin/pg_upgrade/check.c:2182"
reproduced: false
---

# `could not determine parameter settings on new cluster`

## What it means

During `pg_upgrade`, the tool could not read required parameter settings from the new cluster. The tool starts the new server briefly to query settings and could not obtain them. Without these it cannot safely proceed.

## When it happens

Running `pg_upgrade` when the new cluster fails to start or respond, its configuration is broken, or permissions prevent the tool from querying it.

## How to fix

Verify the new cluster can start on its own and that its configuration (`postgresql.conf`, `pg_hba.conf`) is valid, then re-run `pg_upgrade`. Check the tool's log files for the new cluster's startup output, and confirm binary and data-directory paths are correct.

## Example

*Illustrative* — pg_upgrade unable to read new-cluster settings.

```text
pg_upgrade: fatal: could not determine parameter settings on new cluster
```

## Related

- [could not clone file between old and new data directories](./could-not-clone-file-between-old-and-new-data-directories.md)
- [control file appears to be corrupt](./control-file-appears-to-be-corrupt-a3a6c0.md)
