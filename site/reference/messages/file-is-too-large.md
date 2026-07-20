---
message: "file \"%s\" is too large"
slug: file-is-too-large
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/commands/extension.c:4017"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:1354"
  - "postgres/src/fe_utils/version.c:62"
reproduced: false
---

# `file "%s" is too large`

## What it means

A file exceeded the maximum size the operation allows. The placeholder names the file. Some paths (loading an extension script or control file, reading a bounded file into memory) cap the size they will accept; a file beyond that cap is rejected rather than read.

## When it happens

Reading an unexpectedly large file where a bounded size is enforced — for example an extension SQL/control file, or another server-read file that grew past the permitted limit, often a sign the file is not what was expected.

## How to fix

Confirm the file is the one intended and not corrupted or accidentally huge. For extension files, ensure the script is a normal size; if a legitimate need exceeds the limit, split the work or load it differently. Investigate why the file is so large before forcing it through.

## Example

*Illustrative* — an over-large file rejected.

```text
ERROR:  file "myext--1.0.sql" is too large
```

## Related

- [could not read file read of](./could-not-read-file-read-of-2ed767.md)
- [file cloning not supported on this platform](./file-cloning-not-supported-on-this-platform.md)
