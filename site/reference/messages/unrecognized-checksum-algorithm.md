---
message: "unrecognized checksum algorithm: \"%s\""
slug: unrecognized-checksum-algorithm
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/backup/basebackup.c:870"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:205"
reproduced: true
---

# `unrecognized checksum algorithm: "%s"`

## What it means

A tool or backup-manifest reader was given a checksum-algorithm name it does not know, so it could not select a checksum routine.

## When it happens

It arises from `pg_basebackup`/`pg_verifybackup` `--manifest-checksums`, backup-manifest parsing, and related paths when the algorithm name is misspelled or unsupported by this build.

## How to fix

Use one of the supported algorithm names — `NONE`, `CRC32C`, `SHA224`, `SHA256`, `SHA384`, or `SHA512`. Check spelling and case, and confirm the tool version supports the algorithm you named.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__67_backup`); see the reproducer for the triggering workload. It emits:

```text
FATAL:  unrecognized checksum algorithm: "%s"
```

## Related

- [manifest file "%s" contains no entry for file "%s"](./manifest-file-contains-no-entry-for-file.md)
- [zstd is not supported by this build](./zstd-is-not-supported-by-this-build.md)
