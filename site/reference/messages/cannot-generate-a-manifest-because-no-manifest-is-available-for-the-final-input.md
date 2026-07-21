---
message: "cannot generate a manifest because no manifest is available for the final input backup"
slug: cannot-generate-a-manifest-because-no-manifest-is-available-for-the-final-input
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:357"
reproduced: false
---

# `cannot generate a manifest because no manifest is available for the final input backup`

## What it means

`pg_combinebackup` was asked to write a backup manifest for the combined output, but the final input backup in the chain has no manifest of its own. The tool builds the output manifest from the last input's manifest, so a missing one leaves it nothing to base the result on.

## When it happens

It occurs when you run `pg_combinebackup` with manifest generation enabled and the most recent incremental backup in the input set was taken without a manifest, or its `backup_manifest` file is missing.

## How to fix

Retake the final backup with its manifest intact, or run `pg_combinebackup` with `--no-manifest` to skip generating an output manifest. Ensure every backup in an incremental chain keeps its `backup_manifest` file.

## Example

*Illustrative* — a final input backup with no manifest.

```text
pg_combinebackup: error: cannot generate a manifest because no manifest is available for the final input backup
```

## Related

- [cannot inject manifest into a compressed tar file](./cannot-inject-manifest-into-a-compressed-tar-file.md)
- [cannot generate DDL for invalid database](./cannot-generate-ddl-for-invalid-database.md)
