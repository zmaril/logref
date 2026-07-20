---
message: "checkpoint request failed"
slug: checkpoint-request-failed
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/postmaster/checkpointer.c:1186"
reproduced: false
---

# `checkpoint request failed`

## What it means

A backend asked the checkpointer to run a checkpoint and the request did not complete successfully. The failure detail is usually logged separately by the checkpointer, and this error reports that the requested checkpoint did not finish.

## When it happens

It occurs when a command such as `CHECKPOINT`, or an internal operation that forces one, cannot get the checkpointer to complete, often because the checkpointer hit an I/O error or was shut down.

## How to fix

Look in the server log for the checkpointer's own error, which names the underlying cause such as a disk write failure. Resolve that condition, for example free disk space or fix storage, then retry.

## Example

*Illustrative* — a failed checkpoint request.

```text
ERROR:  checkpoint request failed
```

## Related

- [checksum error occurred](./checksum-error-occurred.md)
- [child worker exited abnormally](./child-worker-exited-abnormally.md)
