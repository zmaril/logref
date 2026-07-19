---
message: "finished processing the STREAM ABORT command"
slug: finished-processing-the-stream-abort-command
passthrough: false
api: [elog]
level: [DEBUG1]
call_sites:
  - "postgres/src/backend/replication/logical/worker.c:2127"
  - "postgres/src/backend/replication/logical/worker.c:2230"
reproduced: false
---

# `finished processing the STREAM ABORT command`

## What it means

A debug trace line from a logical-replication apply worker that it finished handling a streamed-transaction ABORT command.

## When it happens

It appears at high debug levels on a subscriber applying streamed (in-progress) transactions when a streamed transaction is aborted and its processing completes.

## Is this a problem?

No action is needed. It is apply-worker diagnostics visible only at raised debug levels. Lower the log level to silence it.

## Example

*Illustrative* — finishing a streamed abort.

```text
DEBUG:  finished processing the STREAM ABORT command
```

## Related

- [finished processing the STREAM COMMIT command](./finished-processing-the-stream-commit-command.md)
- [finished processing the STREAM PREPARE command](./finished-processing-the-stream-prepare-command.md)
