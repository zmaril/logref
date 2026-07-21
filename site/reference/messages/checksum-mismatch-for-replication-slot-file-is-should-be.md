---
message: "checksum mismatch for replication slot file \"%s\": is %u, should be %u"
slug: checksum-mismatch-for-replication-slot-file-is-should-be
passthrough: false
api: [ereport]
level: [PANIC]
call_sites:
  - "postgres/src/backend/replication/slot.c:2809"
reproduced: false
---

# `checksum mismatch for replication slot file "%s": is %u, should be %u`

## What it means

The stored checksum of a replication slot's on-disk state file did not match the value computed from its contents. The slot state file is corrupt, which the server treats as a fatal condition because it cannot trust the slot's position.

## When it happens

It is reached while reading a replication slot's state file during startup or slot access, after storage damage or an incomplete write left the file inconsistent.

## How to fix

This signals corruption of the slot state on disk. Investigate storage health, and recover the slot: on a subscriber or standby the slot may need to be dropped and recreated. Restore from a known-good backup if the damage is broader.

## Example

*Illustrative* — a corrupt slot state file.

```text
PANIC:  checksum mismatch for replication slot file "pg_replslot/s/state": is 123, should be 456
```

## Related

- [checksum mismatch for snapbuild state file is should be](./checksum-mismatch-for-snapbuild-state-file-is-should-be.md)
- [checksum verification failure during base backup](./checksum-verification-failure-during-base-backup.md)
