---
message: "bogus data in lock file \"%s\": \"%s\""
slug: bogus-data-in-lock-file
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/init/miscinit.c:1276"
reproduced: false
---

# `bogus data in lock file "%s": "%s"`

## What it means

The server read a lock file — such as `postmaster.pid` or a socket lock file — and found contents that do not parse as a valid lock file. The placeholders are the file name and the unexpected content.

## When it happens

It occurs at startup or when acquiring a lock file that was truncated, hand-edited, or clobbered by another program sharing the path.

## How to fix

Inspect the named file. If the server is not actually running, remove or repair the stale or corrupt lock file and restart. Ensure no other program writes to the same data directory or socket-lock path.

## Example

*Illustrative* — an unreadable lock file.

```text
FATAL:  bogus data in lock file "postmaster.pid": ""
```

## Related

- [backup label contains data inconsistent with control file](./backup-label-contains-data-inconsistent-with-control-file.md)
- [background process terminated unexpectedly](./background-process-terminated-unexpectedly.md)
