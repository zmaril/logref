---
message: "unexpected command tag \"%s\""
slug: unexpected-command-tag
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/event_trigger.c:675"
  - "postgres/src/backend/commands/event_trigger.c:680"
reproduced: false
---

# `unexpected command tag "%s"`

## What it means

Internal error. Code that interprets command tags (the short strings identifying a completed SQL command, like `SELECT` or `INSERT`) received one it did not expect in that context. The placeholder is the tag.

## When it happens

It fires from paths that branch on command completion tags when the tag does not match any expected case — for example in replication or utility handling that assumes a known set of commands.

## How to fix

This is an internal consistency guard. If a real workload triggers it, capture the statement and context (often replication or an extension) and report it as a reproducible bug.

## Example

*Illustrative* — an unexpected command tag.

```text
ERROR:  unexpected command tag "MOVE"
```

## Related

- [unexpected advice tag: %d](./unexpected-advice-tag.md)
- [query for CALL statement is not a CallStmt](./query-for-call-statement-is-not-a-callstmt.md)
