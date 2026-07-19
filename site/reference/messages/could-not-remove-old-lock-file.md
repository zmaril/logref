---
message: "could not remove old lock file \"%s\": %m"
slug: could-not-remove-old-lock-file
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/init/miscinit.c:1370"
reproduced: false
---

# `could not remove old lock file "%s": %m`

## What it means

During startup the server found a stale lock file it needed to remove and could not delete it. The trailing text is the operating-system error. This is usually an old socket lock file left behind by a previous run.

## When it happens

It fires when the postmaster starts, determines an existing lock file is stale, and tries to clear it before creating a fresh one, but the delete fails.

## How to fix

Check the OS error and the file it names. `Permission denied` means the directory holding the lock file is not writable by the `postgres` OS user — fix ownership. If the file lives in a temporary directory that was cleaned unexpectedly, confirm the path Postgres expects still exists and is writable.

## Example

*Illustrative* — a stale lock file could not be removed.

```text
FATAL:  could not remove old lock file "/tmp/.s.PGSQL.5432.lock": Permission denied
```

## Related

- [could not read lock file](./could-not-read-lock-file.md)
- [data directory has invalid permissions](./data-directory-has-invalid-permissions.md)
