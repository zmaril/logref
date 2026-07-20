---
message: "entry \"%s\" excluded from source file list"
slug: entry-excluded-from-source-file-list
passthrough: false
api: [pg_log_debug]
level: [DEBUG]
call_sites:
  - "postgres/src/bin/pg_rewind/filemap.c:441"
  - "postgres/src/bin/pg_rewind/filemap.c:461"
reproduced: false
---

# `entry "%s" excluded from source file list`

## What it means

A `pg_rewind` debug trace line that a filesystem entry on the source was excluded from the file list it compares, per the tool's exclusion rules.

## When it happens

It appears with `pg_rewind` debug tracing enabled as it walks the source data directory and skips entries it deliberately ignores (temporary files, certain directories).

## Is this a problem?

No action is needed. Excluding non-relevant entries is normal `pg_rewind` behavior. The message is visible only with debug tracing on.

## Example

*Illustrative* — a source entry excluded.

```text
DEBUG:  entry "pg_wal/000000010000000000000001" excluded from source file list
```

## Related

- [entry "%s" excluded from target file list](./entry-excluded-from-target-file-list.md)
- [ignoring file "%s" because no file "%s" exists](./ignoring-file-because-no-file-exists.md)
