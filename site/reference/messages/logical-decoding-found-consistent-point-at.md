---
message: "logical decoding found consistent point at %X/%08X"
slug: logical-decoding-found-consistent-point-at
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/replication/logical/snapbuild.c:1316"
  - "postgres/src/backend/replication/logical/snapbuild.c:1413"
  - "postgres/src/backend/replication/logical/snapbuild.c:1919"
reproduced: false
---

# `logical decoding found consistent point at %X/%08X`

## What it means

A progress message from logical decoding, reporting that snapshot building reached a consistent point at the named log position. From here the decoder can produce a complete, consistent stream of changes. It is expected informational output.

## When it happens

When a logical replication slot is created or a decoder starts and finishes assembling a consistent snapshot of transactions. It marks the position from which decoding can begin emitting changes.

## Is this a problem?

No action is needed. It records normal, healthy progress of logical decoding. The reported position is useful when tracing how far decoding has advanced, but the message itself needs no response.

## Example

*Illustrative* — decoding reaching a consistent point.

```text
LOG:  logical decoding found consistent point at 0/1A2B3C4D
```

## Related

- [no replication origin is configured](./no-replication-origin-is-configured.md)
- [unexpected termination of replication stream](./unexpected-termination-of-replication-stream.md)
