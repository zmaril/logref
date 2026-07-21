---
message: "could not read lock file \"%s\": %m"
slug: could-not-read-lock-file
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/init/miscinit.c:1254"
reproduced: false
---

# `could not read lock file "%s": %m`

## What it means

The server could not read a lock file it needs during startup — typically `postmaster.pid` in the data directory or a socket lock file. The trailing text is the operating-system error.

## When it happens

It fires early in startup when the postmaster reads an existing lock file to check for a running instance. A permission problem, a lock file on unreadable storage, or an I/O fault triggers it.

## How to fix

Check the OS error and the file it names. `Permission denied` means the `postgres` OS user cannot read it — fix ownership on the data directory. If the file is damaged and no server is actually running, you can remove the stale lock file and start again, but confirm no live postmaster owns it first.

## Example

*Illustrative* — the postmaster could not read its lock file.

```text
FATAL:  could not read lock file "postmaster.pid": Permission denied
```

## Related

- [could not remove old lock file](./could-not-remove-old-lock-file.md)
- [data directory has invalid permissions](./data-directory-has-invalid-permissions.md)
