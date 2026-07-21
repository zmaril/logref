---
message: "invalid data in file \"%s\""
slug: invalid-data-in-file
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/access/transam/xlogrecovery.c:1209"
  - "postgres/src/backend/access/transam/xlogrecovery.c:1216"
  - "postgres/src/backend/access/transam/xlogrecovery.c:1275"
  - "postgres/src/backend/access/transam/xlogrecovery.c:1363"
  - "postgres/src/backend/access/transam/xlogrecovery.c:1372"
  - "postgres/src/backend/access/transam/xlogrecovery.c:1392"
reproduced: false
---

# `invalid data in file "%s"`

## What it means

A file the server reads during startup or recovery contained contents that failed validation — the bytes were present but did not parse into the structure the reader expected. The placeholder is the path. Because this fires at `FATAL` during recovery, startup is aborted.

## When it happens

Reading a control or state file such as a backup label or a saved recovery file whose contents are truncated, hand-edited, or corrupted, or that belong to a different cluster or version.

## How to fix

Identify the named file and treat it as corrupt. If it is a leftover `backup_label` or similar transient file from an interrupted backup, and you understand the recovery state, removing the stale file may let startup proceed — but do this only with a backup in hand, as a wrong move can lose data. For a genuinely damaged control file, restore from backup.

## Example

*Illustrative* — a damaged state file read at recovery.

```text
FATAL:  invalid data in file "backup_label"
```

## Related

- [could not read from file](./could-not-read-from-file.md)
- [calculated CRC checksum does not match value stored in file](./calculated-crc-checksum-does-not-match-value-stored-in-file-46deed.md)
