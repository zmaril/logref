---
message: "finished processing the STREAM PREPARE command"
slug: finished-processing-the-stream-prepare-command
passthrough: false
api: [elog]
level: [DEBUG1]
call_sites:
  - "postgres/src/backend/replication/logical/worker.c:1587"
  - "postgres/src/backend/replication/logical/worker.c:1649"
reproduced: false
---

# `finished processing the STREAM PREPARE command`

## What it means

A debug trace line from a logical-replication apply worker that it finished handling a streamed-transaction PREPARE command.

## When it happens

It appears at high debug levels on a subscriber applying streamed two-phase transactions when a streamed transaction is prepared and its processing completes.

## Is this a problem?

No action is needed. It is apply-worker diagnostics visible only at raised debug levels. Lower the log level to silence it.

## Example

*Illustrative* — finishing a streamed prepare.

```text
DEBUG:  finished processing the STREAM PREPARE command
```

## Related

- [finished processing the STREAM ABORT command](./finished-processing-the-stream-abort-command.md)
- [finished processing the STREAM COMMIT command](./finished-processing-the-stream-commit-command.md)
