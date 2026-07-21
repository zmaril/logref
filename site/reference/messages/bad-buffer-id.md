---
message: "bad buffer ID: %d"
slug: bad-buffer-id
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:715"
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:832"
reproduced: false
---

# `bad buffer ID: %d`

## What it means

Internal error. A pg_buffercache inspection routine was given a shared-buffer identifier outside the valid range. Buffer identifiers index the shared buffer pool, and this one did not correspond to a real buffer.

## When it happens

It should not occur through normal use of the buffer-cache inspection functions. Reaching it points to an internal inconsistency rather than to your query.

## How to fix

Treat it as an internal bug. Capture the operation that surfaced it — typically a `pg_buffercache` query — and report it. There is no user-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — an out-of-range buffer identifier.

```text
ERROR:  bad buffer ID: 999999
```

## Related

- [autoprewarm worker is already running under pid](./autoprewarm-worker-is-already-running-under-pid.md)
- [invalid index offnum](./invalid-index-offnum.md)
