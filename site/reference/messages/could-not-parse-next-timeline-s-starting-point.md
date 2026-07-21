---
message: "could not parse next timeline's starting point \"%s\""
slug: could-not-parse-next-timeline-s-starting-point
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/receivelog.c:733"
reproduced: false
---

# `could not parse next timeline's starting point "%s"`

## What it means

While streaming WAL, `pg_basebackup` (or `pg_receivewal`) read the history describing where the next timeline begins and could not parse the starting point. The `%s` value gives the raw text. Timeline history marks where the WAL forks after a promotion.

## When it happens

It happens during WAL streaming across a timeline switch, when the server's timeline-history reply is not in the expected form — usually a protocol or version mismatch, or unexpected history contents.

## How to fix

Make sure the client and server versions are compatible, since a mismatched WAL streaming protocol can present this way. If versions match, capture the reported text and the surrounding tool output and report a reproducible case.

## Example

*Illustrative* — an unparsable timeline starting point.

```text
pg_receivewal: error: could not parse next timeline's starting point "garbage"
```

## Related

- [could not parse start position](./could-not-parse-start-position.md)
- [could not parse TLI for](./could-not-parse-tli-for.md)
