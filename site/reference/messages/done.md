---
message: "Done!"
slug: done
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2713"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:554"
reproduced: false
---

# `Done!`

## What it means

An informational message that a tool or operation has finished, printed as a terminal progress marker.

## When it happens

It arises at the end of a step in various command-line tools to signal completion of the work just performed.

## Is this a problem?

No action is needed. It reports successful completion of a step.

## Example

*Illustrative* — a completion marker.

```text
Done!
```

## Related

- [finished item %d %s %s](./finished-item.md)
- [executing %s](./executing-ddcf88.md)
