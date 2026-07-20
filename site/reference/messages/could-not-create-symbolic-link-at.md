---
message: "could not create symbolic link at \"%s\": %m"
slug: could-not-create-symbolic-link-at
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/file_ops.c:286"
reproduced: false
---

# `could not create symbolic link at "%s": %m`

## What it means

`pg_rewind` could not create a symbolic link it needs in the target data directory. The `%m` reason gives the OS error. Symbolic links appear for tablespaces and similar directory pointers.

## When it happens

It happens while `pg_rewind` rebuilds the target's directory layout, when creating a symlink fails — a permissions problem, a full filesystem, or a filesystem that does not support symlinks.

## How to fix

Check permissions and free space on the target directory and confirm the filesystem supports symbolic links. Resolve the problem and rerun the rewind from a known-good starting point.

## Example

*Illustrative* — a symlink that cannot be created during rewind.

```text
pg_rewind: fatal: could not create symbolic link at "pg_tblspc/16400": Permission denied
```

## Related

- [could not close target file](./could-not-close-target-file.md)
- [could not decide what to do with file](./could-not-decide-what-to-do-with-file.md)
