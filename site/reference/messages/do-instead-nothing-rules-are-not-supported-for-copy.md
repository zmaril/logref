---
message: "DO INSTEAD NOTHING rules are not supported for COPY"
slug: do-instead-nothing-rules-are-not-supported-for-copy
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copyto.c:928"
reproduced: false
---

# `DO INSTEAD NOTHING rules are not supported for COPY`

## What it means

`COPY` targeted a relation that has a `DO INSTEAD NOTHING` rule. Such a rule would suppress the operation, and `COPY` cannot honour it, so `COPY` is rejected.

## When it happens

It fires from `COPY table FROM`/`TO` when the table has a `DO INSTEAD NOTHING` rule on the relevant event.

## How to fix

Copy a base table without such a rule, or load through an intermediate table. If the rule exists to block writes, respect that intent and use a different target; if not, adjust or drop the rule.

## Example

*Illustrative* — copying a table with a DO INSTEAD NOTHING rule.

```text
ERROR:  DO INSTEAD NOTHING rules are not supported for COPY
```

## Related

- [DO ALSO rules are not supported for COPY](./do-also-rules-are-not-supported-for-copy.md)
- [DO INSTEAD NOTHING rules are not supported for data-modifying statements in WITH](./do-instead-nothing-rules-are-not-supported-for-data-modifying-statements-in-with.md)
