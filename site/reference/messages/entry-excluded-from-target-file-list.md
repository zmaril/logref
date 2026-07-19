---
message: "entry \"%s\" excluded from target file list"
slug: entry-excluded-from-target-file-list
passthrough: false
api: [pg_log_debug]
level: [DEBUG]
call_sites:
  - "postgres/src/bin/pg_rewind/filemap.c:444"
  - "postgres/src/bin/pg_rewind/filemap.c:464"
reproduced: false
---

# `entry "%s" excluded from target file list`

## What it means

A `pg_rewind` debug trace line that a filesystem entry on the target was excluded from the file list it compares, per the tool's exclusion rules.

## When it happens

It appears with `pg_rewind` debug tracing enabled as it walks the target data directory and skips entries it deliberately ignores.

## Is this a problem?

No action is needed. Excluding non-relevant entries is normal `pg_rewind` behavior. The message is visible only with debug tracing on.

## Example

*Illustrative* — a target entry excluded.

```text
DEBUG:  entry "pg_wal/000000010000000000000001" excluded from target file list
```

## Related

- [entry "%s" excluded from source file list](./entry-excluded-from-source-file-list.md)
- [ignoring file "%s" because no file "%s" exists](./ignoring-file-because-no-file-exists.md)
