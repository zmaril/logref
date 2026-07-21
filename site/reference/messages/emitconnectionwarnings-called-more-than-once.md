---
message: "EmitConnectionWarnings() called more than once"
slug: emitconnectionwarnings-called-more-than-once
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/init/postinit.c:1549"
reproduced: false
---

# `EmitConnectionWarnings() called more than once`

## What it means

An internal guard in backend session setup. The routine that emits post-connection warnings was invoked twice for one session, which should happen only once. This is a "can't happen" check.

## When it happens

It fires during backend initialization if the connection-warning step runs a second time, indicating an internal ordering bug rather than anything a client controls.

## How to fix

This is not a user-facing condition. If it reproduces, capture the log and server version and report it to the PostgreSQL developers. It does not indicate a problem with the client connection itself.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  EmitConnectionWarnings() called more than once
```

## Related

- [empty password returned by client](./empty-password-returned-by-client.md)
- [entry ref vanished before deletion](./entry-ref-vanished-before-deletion.md)
