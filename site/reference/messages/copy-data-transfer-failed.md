---
message: "COPY data transfer failed: %s"
slug: copy-data-transfer-failed
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/copy.c:467"
reproduced: false
---

# `COPY data transfer failed: %s`

## What it means

psql's `\copy` failed while transferring data between the client and server. The message includes the underlying reason. The copy did not complete.

## When it happens

It happens during a client-side `\copy` when the data stream is interrupted — a broken connection, a server-side error mid-copy, or a local file problem.

## How to fix

Read the reason in the message and address it. Check the local file, the connection stability, and any server-side error (such as a bad row) that aborted the copy. Fix the cause and rerun `\copy`.

## Example

*Illustrative* — a failed \copy transfer.

```text
\copy: COPY data transfer failed: ...
```

## Related

- [\copy: arguments required](./copy-arguments-required.md)
- [COPY stream ended before last file was finished](./copy-stream-ended-before-last-file-was-finished.md)
