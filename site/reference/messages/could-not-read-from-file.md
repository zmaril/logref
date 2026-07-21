---
message: "could not read from file \"%s\": %m"
slug: could-not-read-from-file
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL, LOG]
call_sites:
  - "postgres/contrib/pg_prewarm/autoprewarm.c:340"
  - "postgres/src/backend/utils/init/miscinit.c:1545"
  - "postgres/src/backend/utils/init/miscinit.c:1687"
  - "postgres/src/backend/utils/misc/guc.c:5667"
  - "postgres/src/bin/pg_combinebackup/copy_file.c:213"
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:789"
reproduced: false
---

# `could not read from file "%s": %m`

## What it means

Reading from an already-open file failed. The path is the first placeholder and `%m` the OS error. This form is used where the file was opened successfully and a subsequent read failed — configuration includes, autoprewarm dumps, control/state files.

## When it happens

Reading config, an autoprewarm file, `pg_control`, or a copied file mid-operation. Common `%m`: `Input/output error` (failing storage) or `Bad file descriptor`. A short read of a critical file may instead surface as the "read %d of %zu" form.

## How to fix

Read `%m`. `Input/output error` points at failing storage — check disk health, especially for control/data files. For non-critical files (like an autoprewarm dump) the impact may be limited to that feature, but still investigate the storage. Restore or regenerate the file if it is damaged.

## Example

*Illustrative* — reading a config include on failing storage.

```text
ERROR:  could not read from file "postgresql.conf": Input/output error
```

## Related

- [could not read file](./could-not-read-file-54f73a.md)
- [could not read from input file: %m](./could-not-read-from-input-file-c5612a.md)
