---
message: "manifest file \"%s\" contains no entry for file \"%s\""
slug: manifest-file-contains-no-entry-for-file
passthrough: false
api: [pg_log_warning]
level: [WARNING]
call_sites:
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:1095"
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:305"
reproduced: false
---

# `manifest file "%s" contains no entry for file "%s"`

## What it means

A warning from backup verification that a file present in the backup has no matching entry in the backup manifest, so it cannot be checked against the manifest.

## When it happens

It arises from `pg_verifybackup` when the data directory contains a file the manifest does not list — an extra file, or a manifest that does not match the backup.

## Is this a problem?

Determine whether the extra file is expected (some runtime files are). If it is unexpected, the backup or manifest may be inconsistent; re-take the backup and its manifest together, and verify again.

## Example

*Illustrative* — a file missing from the manifest.

```text
WARNING:  manifest file "backup_manifest" contains no entry for file "base/16401/12345"
```

## Related

- [ignoring file "%s" because no file "%s" exists](./ignoring-file-because-no-file-exists.md)
- [unrecognized checksum algorithm: "%s"](./unrecognized-checksum-algorithm.md)
