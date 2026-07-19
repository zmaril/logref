---
message: "could not generate temporary file name for archiving"
slug: could-not-generate-temporary-file-name-for-archiving
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/basic_archive/basic_archive.c:195"
reproduced: false
---

# `could not generate temporary file name for archiving`

## What it means

The `basic_archive` example archive module tried to create a unique temporary file name in the archive directory and could not. It writes each WAL segment to a temporary name first, then renames it into place so the archived copy is never partial.

## When it happens

It fires while archiving WAL through `basic_archive`, when the temporary name cannot be generated — usually an archive directory that is missing, unwritable, or full.

## How to fix

Check that the configured archive directory exists, is writable by the server, and has free space. `basic_archive` is a sample module; production setups usually use a purpose-built `archive_command` or `archive_library`. Fix the directory and archiving resumes.

## Example

*Illustrative* — basic_archive cannot create a scratch name.

```text
ERROR:  could not generate temporary file name for archiving
```

## Related

- [could not generate temporary file name](./could-not-generate-temporary-file-name.md)
- [could not fsync existing write-ahead log file](./could-not-fsync-existing-write-ahead-log-file.md)
