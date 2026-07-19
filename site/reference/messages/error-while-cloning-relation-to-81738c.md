---
message: "error while cloning relation \"%s.%s\" (\"%s\" to \"%s\"): %s"
slug: error-while-cloning-relation-to-81738c
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/file.c:61"
reproduced: false
---

# `error while cloning relation "%s.%s" ("%s" to "%s"): %s`

## What it means

During `pg_upgrade` in clone mode, cloning a relation's file failed with a library-reported error. The placeholders are the schema-qualified relation, the source and target files, and the error string.

## When it happens

It fires in `pg_upgrade` while cloning relation files into the new cluster, when the clone operation fails for a reason reported as a string.

## How to fix

Check the reported error and the destination filesystem's clone support. Clone mode needs a filesystem with reflink support; on others, run `pg_upgrade` in copy mode (drop `--clone`). Ensure the target has space and is healthy, then rerun.

## Example

*Illustrative* — a relation clone failure.

```text
pg_upgrade: error: error while cloning relation "public.t" ("/old/..." to "/new/..."): ...
```

## Related

- [error while cloning relation to](./error-while-cloning-relation-to-87b802.md)
- [error while cloning relation could not create file](./error-while-cloning-relation-could-not-create-file.md)
