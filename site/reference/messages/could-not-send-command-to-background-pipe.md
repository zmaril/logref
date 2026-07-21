---
message: "could not send command to background pipe: %m"
slug: could-not-send-command-to-background-pipe
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2227"
reproduced: false
---

# `could not send command to background pipe: %m`

## What it means

`pg_basebackup` could not send a command to its background worker over their internal pipe. The trailing text is the operating-system error. The pipe coordinates the main process and the child that streams data.

## When it happens

It fires while `pg_basebackup` runs with a background worker and the write to the coordinating pipe fails, usually because the child has already exited.

## How to fix

The background worker most likely died — look earlier in the output for its real error, such as a server disconnect or a disk-full target. Fix that condition and rerun the backup. This message is the symptom of the child going away, not the root cause.

## Example

*Illustrative* — the background pipe write failed.

```text
pg_basebackup: error: could not send command to background pipe: Broken pipe
```

## Related

- [could not read from ready pipe](./could-not-read-from-ready-pipe.md)
- [could not wait for child process](./could-not-wait-for-child-process.md)
