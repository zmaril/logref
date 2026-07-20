---
message: "custom scan \"%s\" does not support MarkPos"
slug: custom-scan-does-not-support-markpos
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/nodeCustom.c:142"
  - "postgres/src/backend/executor/nodeCustom.c:153"
reproduced: false
---

# `custom scan "%s" does not support MarkPos`

## What it means

Internal error involving a custom-scan provider. The executor asked a custom scan node to mark or restore its position (`MarkPos`), and that provider does not implement it. The `%s` is the custom-scan name.

## When it happens

A plan placed a mark/restore-requiring node (for example a merge join) above a custom scan whose provider did not advertise or implement `MarkPos`. It arises with third-party custom-scan extensions.

## How to fix

This is an extension-contract issue. Update or fix the custom-scan provider so it supports mark/restore, or avoid plan shapes that require it above that node. Report it to the extension's authors.

## Example

*Illustrative* — a custom scan asked to mark position.

```text
ERROR:  custom scan "my_scan" does not support MarkPos
```

## Related

- [foreign-data wrapper has no handler](./foreign-data-wrapper-has-no-handler.md)
- [failed to build any-way joins](./failed-to-build-any-way-joins.md)
