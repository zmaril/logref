---
message: "error while cloning relation \"%s.%s\" (\"%s\" to \"%s\"): %m"
slug: error-while-cloning-relation-to-87b802
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/file.c:40"
reproduced: false
---

# `error while cloning relation "%s.%s" ("%s" to "%s"): %m`

## What it means

During `pg_upgrade` in clone mode, cloning a relation's file failed with an operating-system error. The placeholders are the schema-qualified relation, the source and target files, and the OS error.

## When it happens

It fires in `pg_upgrade` while cloning relation files, when the clone hits an errno such as an unsupported operation, a permission problem, or a full disk.

## How to fix

Read the OS error. `Operation not supported` means the filesystem lacks reflink support — use copy mode (drop `--clone`). `No space left on device` means free the target. `Invalid cross-device link` means source and target are on different filesystems, which clone cannot span. Fix and rerun.

## Example

*Illustrative* — a relation clone failure.

```text
pg_upgrade: error: error while cloning relation "public.t" ("/old/..." to "/new/..."): Operation not supported
```

## Related

- [error while cloning relation to](./error-while-cloning-relation-to-81738c.md)
- [error while copying relation: could not copy file range from to](./error-while-copying-relation-could-not-copy-file-range-from-to.md)
