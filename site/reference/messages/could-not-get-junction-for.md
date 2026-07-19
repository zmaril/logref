---
message: "could not get junction for \"%s\": %s"
slug: could-not-get-junction-for
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/port/dirmod.c:362"
reproduced: false
---

# `could not get junction for "%s": %s`

## What it means

On Windows, Postgres tried to read the target of a directory junction (the Windows equivalent of a symbolic link) and the call failed. The `%s` value gives the reason. Tablespaces are stored as junctions in the data directory.

## When it happens

It fires while resolving a tablespace junction on Windows — for example during startup, backup, or maintenance — when the junction is broken, points at a missing target, or is not readable.

## How to fix

Check that the tablespace's target directory exists and is accessible, and that the junction under `pg_tblspc` is intact. Recreating a broken junction to the correct target, with the service account able to read it, resolves it.

## Example

*Illustrative* — a tablespace junction that could not be read.

```text
ERROR:  could not get junction for "pg_tblspc/16400": The system cannot find the path specified.
```

## Related

- [could not get current working directory](./could-not-get-current-working-directory.md)
- [could not get home directory for user id](./could-not-get-home-directory-for-user-id.md)
