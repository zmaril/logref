---
message: "file cloning not supported on this platform"
slug: file-cloning-not-supported-on-this-platform
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/copy_file.c:259"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:263"
  - "postgres/src/bin/pg_upgrade/file.c:229"
reproduced: false
---

# `file cloning not supported on this platform`

## What it means

A tool was asked to use file cloning (copy-on-write reflinks) but the platform or filesystem does not support it. The placeholder-free message means the `--clone`-style fast-copy option cannot be honored here, so the tool stops rather than silently falling back.

## When it happens

Running `pg_upgrade` or `pg_combinebackup` with a clone/reflink option on an OS or filesystem without copy-on-write support (for example a filesystem that is not XFS-with-reflinks, Btrfs, APFS, or ZFS with the needed capability).

## How to fix

Use a copy method the platform supports: drop the clone option to copy normally, or use `--copy`/hard-link modes as available for the tool. If you want cloning's speed and space savings, place the data on a filesystem that supports reflinks (and an OS build that exposes it), then retry with the clone option.

## Example

*Illustrative* — a clone request on an unsupported filesystem.

```text
pg_combinebackup: error: file cloning not supported on this platform
```

## Related

- [could not change permissions of directory](./could-not-change-permissions-of-directory.md)
- [data directory is of wrong version](./data-directory-is-of-wrong-version.md)
