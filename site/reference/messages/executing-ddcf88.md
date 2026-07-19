---
message: "executing %s"
slug: executing-ddcf88
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/pg_dump/connectdb.c:282"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:1778"
reproduced: false
---

# `executing %s`

## What it means

An informational message reporting the command a tool is about to run, printed for visibility into its actions.

## When it happens

It arises from command-line tools (for example during upgrade or maintenance steps) that echo each command they execute so the operator can follow along.

## Is this a problem?

No action is needed. It is progress output naming the current step. It is useful for tracing what a tool did if a later step fails.

## Example

*Illustrative* — echoing a command.

```text
INFO:  executing ANALYZE
```

## Related

- [done](./done.md)
- [finished item %d %s %s](./finished-item.md)
