---
message: "could not set junction for \"%s\": %s"
slug: could-not-set-junction-for
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/port/dirmod.c:282"
reproduced: false
---

# `could not set junction for "%s": %s`

## What it means

On Windows, the server could not create a junction point for a directory. The placeholder is the target and the trailing text is the reason. Junctions are how Windows builds implement tablespace symbolic links.

## When it happens

It fires when creating a tablespace, or otherwise linking a directory on Windows, and the junction cannot be established — a permission problem, or a path on a filesystem that does not support junctions.

## How to fix

Make sure the tablespace location is on an NTFS volume that supports junctions and that the `postgres` service account can create them there. Check that the target directory is empty and writable. Correct the location or permissions and retry the tablespace operation.

## Example

*Illustrative* — a tablespace junction could not be created.

```text
ERROR:  could not set junction for "D:\\pgdata\\ts1": access is denied
```

## Related

- [could not synchronize directory](./could-not-synchronize-directory.md)
- [data directory has invalid permissions](./data-directory-has-invalid-permissions.md)
