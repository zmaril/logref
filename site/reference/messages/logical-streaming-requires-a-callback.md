---
message: "logical streaming requires a %s callback"
slug: logical-streaming-requires-a-callback
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/logical/logical.c:1297"
  - "postgres/src/backend/replication/logical/logical.c:1346"
  - "postgres/src/backend/replication/logical/logical.c:1387"
  - "postgres/src/backend/replication/logical/logical.c:1473"
  - "postgres/src/backend/replication/logical/logical.c:1522"
reproduced: false
---

# `logical streaming requires a %s callback`

## What it means

A logical-decoding output plugin was used with streaming of in-progress transactions enabled, but the plugin did not register the required streaming callback. The placeholder names the missing callback. Streaming needs the plugin to implement specific stream-start/stop/commit handlers.

## When it happens

Creating or reading a logical replication slot with streaming enabled against an output plugin that does not implement the full set of streaming callbacks — typically an extension plugin written for non-streaming decoding.

## How to fix

Either disable streaming for that slot/subscription, or use an output plugin that implements the streaming callbacks. If you maintain the plugin, add the missing stream callbacks; if it is third-party, use it in non-streaming mode or update it.

## Example

*Illustrative* — streaming requested from a plugin lacking the callback.

```text
ERROR:  logical streaming requires a stream_stop callback
```

## Related

- [unexpected apply action](./unexpected-apply-action.md)
- [replication slot does not exist](./replication-slot-does-not-exist.md)
