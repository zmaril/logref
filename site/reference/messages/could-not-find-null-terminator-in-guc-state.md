---
message: "could not find null terminator in GUC state"
slug: could-not-find-null-terminator-in-guc-state
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:6054"
reproduced: false
---

# `could not find null terminator in GUC state`

## What it means

A parallel worker reading serialized configuration (GUC) state from its leader could not find the expected string terminator. This is an internal consistency check on the shared GUC-state blob.

## When it happens

It fires when a parallel worker deserializes the settings passed from the leader and the byte stream is malformed. Reaching it points at an internal problem rather than user configuration.

## How to fix

This is an internal error in the parallel-worker state transfer. As a workaround, disabling parallel query for the session (`SET max_parallel_workers_per_gather = 0`) avoids the transfer. Note the query and report a reproducible case.

## Example

*Illustrative* — a malformed GUC-state blob.

```text
ERROR:  could not find null terminator in GUC state
```

## Related

- [could not find enum option for](./could-not-find-enum-option-for.md)
- [could not find custom name for wait event information](./could-not-find-custom-name-for-wait-event-information.md)
