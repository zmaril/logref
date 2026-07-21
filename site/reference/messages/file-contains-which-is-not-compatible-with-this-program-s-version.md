---
message: "File \"%s\" contains \"%s\", which is not compatible with this program's version \"%s\"."
slug: file-contains-which-is-not-compatible-with-this-program-s-version
passthrough: false
api: [pg_log_error_detail]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:475"
  - "postgres/src/bin/pg_checksums/pg_checksums.c:558"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:580"
reproduced: false
---

# `File "%s" contains "%s", which is not compatible with this program's version "%s".`

## What it means

A tool read a file whose recorded version does not match the tool's version. The placeholders are the file name, the version string found, and the program's own version. Metadata files (control data, backup manifests, state files) carry a version stamp so tools refuse to misinterpret content written by an incompatible version.

## When it happens

Running a tool against a file produced by a different major PostgreSQL version — mixing binaries and data across versions, or using an older tool on a newer file (or vice versa).

## How to fix

Use a tool whose version matches the file's, or regenerate the file with the matching version. For upgrade workflows, run each step with binaries that match the data/file version, and use `pg_upgrade` to move between major versions rather than reading cross-version files directly.

## Example

*Illustrative* — a version-stamped file read by the wrong tool.

```text
File "data" contains "15", which is not compatible with this program's version "16".
```

## Related

- [data directory is of wrong version](./data-directory-is-of-wrong-version.md)
- [could not parse](./could-not-parse.md)
