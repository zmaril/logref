---
message: "NEW (%d)"
slug: new
passthrough: false
api: [elog]
level: [varies]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:3824"
  - "postgres/src/backend/utils/adt/formatting.c:4879"
reproduced: false
---

# `NEW (%d)`

## What it means

A debug trace fragment printing a `NEW` marker with a number, used in low-level tracing of date/time formatting-node processing.

## When it happens

It appears only under deep tracing of the formatting code (for example `to_char`/`to_timestamp` node handling), emitting an internal marker.

## Is this a problem?

No action is needed. It is internal formatting-diagnostics output visible only at the highest debug levels. Lower the log level to silence it.

## Example

*Illustrative* — a formatting-node trace marker.

```text
NEW (3)
```

## Related

- [key (%u, %u) -> %u](./key.md)
- [done](./done.md)
