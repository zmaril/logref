---
message: "skipping cleanup for portal \"%s\""
slug: skipping-cleanup-for-portal
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/utils/mmgr/portalmem.c:903"
  - "postgres/src/backend/utils/mmgr/portalmem.c:1122"
reproduced: false
---

# `skipping cleanup for portal "%s"`

## What it means

During error recovery the server chose not to clean up a named portal (an open cursor or query executor) because it was not in a state where cleanup was safe or applicable.

## When it happens

It is logged at WARNING in unusual transaction-abort paths where a portal is encountered that cannot be torn down normally, typically after an earlier failure left it in an inconsistent state.

## Is this a problem?

This is an internal recovery notice, not a user-facing error. It usually follows another error that is the real problem — look earlier in the log. If it recurs, capture the surrounding messages and the workload that triggers it for a bug report.

## Example

*Illustrative* — a portal skipped during abort cleanup.

```text
WARNING:  skipping cleanup for portal "my_cursor"
```

## Related

- [skipping special file](./skipping-special-file.md)
- [already connected to a database](./already-connected-to-a-database.md)
