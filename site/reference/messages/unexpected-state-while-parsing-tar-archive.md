---
message: "unexpected state while parsing tar archive"
slug: unexpected-state-while-parsing-tar-archive
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_verifybackup/astreamer_verify.c:130"
  - "postgres/src/fe_utils/astreamer_tar.c:254"
reproduced: false
---

# `unexpected state while parsing tar archive`

## What it means

Internal error in a tar-reading tool. The tar parser reached a state its state machine does not account for while walking a tar stream (a base backup or archive).

## When it happens

It fires in tools such as `pg_basebackup` or `pg_verifybackup` when the tar stream is malformed or truncated, or when the parser's bookkeeping falls out of step.

## How to fix

This is a consistency guard over the tar reader. Verify the archive or base-backup stream is complete and untruncated; re-fetch it if the source was interrupted, and report a reproducible case with the archive if it holds.

## Example

*Illustrative* — a malformed tar stream.

```text
FATAL:  unexpected state while parsing tar archive
```

## Related

- [unknown file type for "%s"](./unknown-file-type-for.md)
- [archive items not in correct section order](./archive-items-not-in-correct-section-order.md)
