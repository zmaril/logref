---
message: "copy_file_range not supported on this platform"
slug: copy-file-range-not-supported-on-this-platform
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/copy_file.c:299"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:276"
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:729"
  - "postgres/src/bin/pg_upgrade/file.c:266"
reproduced: false
---

# `copy_file_range not supported on this platform`

## What it means

A tool requested the `copy_file_range` fast-copy method and the operating system or filesystem does not provide it. The placeholder-free text comes from tools like `pg_combinebackup` that can clone file ranges efficiently where the platform supports it.

## When it happens

Running `pg_combinebackup` (or a similar tool) with the `copy_file_range` clone mode on a platform, kernel, or filesystem that lacks that system call or does not support it between the source and destination.

## How to fix

Use a copy method the platform supports — the default byte copy, or another `--clone`/`--copy` mode the tool offers. `copy_file_range` requires a recent Linux kernel and a filesystem that supports it; fall back to the standard copy where it is unavailable.

## Example

*Illustrative* — an unsupported fast-copy mode.

```text
FATAL:  copy_file_range not supported on this platform
```

## Related

- [could not create symbolic link](./could-not-create-symbolic-link.md)
- [could not access file](./could-not-access-file.md)
