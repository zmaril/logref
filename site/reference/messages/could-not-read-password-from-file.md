---
message: "could not read password from file \"%s\": %m"
slug: could-not-read-password-from-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:1721"
reproduced: false
---

# `could not read password from file "%s": %m`

## What it means

`initdb` was told to read the new superuser's password from a file and the read failed. The placeholder is the file path and the trailing text is the operating-system error.

## When it happens

It happens during `initdb` when you pass `--pwfile` and the named file cannot be read — a wrong path, a permission problem, or an I/O error.

## How to fix

Confirm the file exists at the path you gave and that the user running `initdb` can read it. The file should contain the password on its first line. Fix the path or permissions and rerun.

## Example

*Illustrative* — the password file could not be read.

```text
initdb: error: could not read password from file "pwfile": No such file or directory
```

## Related

- [could not read line from file](./could-not-read-line-from-file.md)
- [could not read input file](./could-not-read-input-file.md)
