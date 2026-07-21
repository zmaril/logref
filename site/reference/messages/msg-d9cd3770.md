---
message: "%s: %s"
slug: msg-d9cd3770
passthrough: true
api: [elog, pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/contrib/dblink/dblink.c:180"
  - "postgres/src/bin/psql/command.c:3333"
  - "postgres/src/bin/psql/copy.c:388"
reproduced: false
---

# `%s: %s`

## What it means

This is a passthrough message of the form `label: detail`, emitted by client tools and helper code to relay an underlying message together with a short label. The meaning depends entirely on the two parts substituted in — the label names the context and the detail carries the real content.

## When it happens

Wherever a tool wraps a lower-level result in a short prefix — for example a psql command reporting a sub-result, or `dblink` relaying a message from a remote server. It is a formatting shell, so the trigger is whatever produced the detail text.

## How to fix

Read the detail portion after the colon; it holds the actual message. Address whatever that underlying text describes, and use the label to identify which operation or component produced it.

## Example

*Illustrative* — a labelled passthrough message.

```text
ERROR:  dblink: could not connect to remote server
```

## Related

- [unexpected termination of replication stream](./unexpected-termination-of-replication-stream.md)
- [target key array length must match number of key attributes](./target-key-array-length-must-match-number-of-key-attributes.md)
