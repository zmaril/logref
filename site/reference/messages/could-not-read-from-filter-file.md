---
message: "could not read from filter file \"%s\": %m"
slug: could-not-read-from-filter-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/filter.c:243"
  - "postgres/src/bin/pg_dump/filter.c:470"
reproduced: false
---

# `could not read from filter file "%s": %m`

## What it means

`pg_dump` or `pg_restore` could not read from a `--filter` file. The `%s` is the path and the `%m` is the operating-system error. Object-selection rules could not be loaded.

## When it happens

The filter file became unreadable mid-read — an I/O error, or the file was removed or truncated after it was opened.

## How to fix

Confirm the filter file is present, readable, and stable for the run. Re-create it if it was truncated, and rerun the dump or restore.

## Example

*Illustrative* — an I/O error reading the filter file.

```text
pg_dump: error: could not read from filter file "objects.txt": Input/output error
```

## Related

- [could not read file](./could-not-read-file-read-of-a9ed38.md)
- [could not open input file](./could-not-open-input-file-d824fe.md)
