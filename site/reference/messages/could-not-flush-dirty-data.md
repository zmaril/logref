---
message: "could not flush dirty data: %m"
slug: could-not-flush-dirty-data
passthrough: false
api: [ereport]
level: [WARNING]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/storage/file/fd.c:582"
  - "postgres/src/backend/storage/file/fd.c:654"
  - "postgres/src/backend/storage/file/fd.c:690"
reproduced: false
---

# `could not flush dirty data: %m`

## What it means

The server failed to flush modified file data to storage. It reports the operating-system error from the flush attempt. Raised as a warning, it signals that a durability-related flush did not complete as requested.

## When it happens

A flush of dirty file buffers to disk returned an OS error — for example on a filesystem that does not support the flush operation the server tried, or under a storage-level failure. It can appear on certain filesystems or unusual storage setups.

## Is this a problem?

Read the system error detail. If the filesystem does not support the attempted flush method, the warning may be benign but worth understanding; if it stems from a storage fault, treat it as a durability risk and check disk and filesystem health. Persistent flush failures on a healthy system deserve investigation, since they touch data durability.

## Example

*Illustrative* — a failed data flush.

```text
WARNING:  could not flush dirty data: Function not implemented
```

## Related

- [this build does not support sync method](./this-build-does-not-support-sync-method.md)
- [could not fsync file](./could-not-fsync-file-5db846.md)
