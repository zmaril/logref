---
message: "DO ALSO rules are not supported for COPY"
slug: do-also-rules-are-not-supported-for-copy
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copyto.c:946"
reproduced: false
---

# `DO ALSO rules are not supported for COPY`

## What it means

`COPY` targeted a relation that has a `DO ALSO` rule. `COPY` cannot run the additional actions a `DO ALSO` rule specifies, so it is rejected. The rewrite system does not support such rules for `COPY`.

## When it happens

It fires from `COPY table TO` (or `FROM`) when the table has a rule with a `DO ALSO` action attached to the relevant event.

## How to fix

`COPY` a base table without conflicting rules, or copy the data through an intermediate table. If you need rule side effects, use `INSERT ... SELECT` instead of `COPY`, since ordinary DML honours the rules.

## Example

*Illustrative* — copying a table with a DO ALSO rule.

```text
ERROR:  DO ALSO rules are not supported for COPY
```

## Related

- [DO INSTEAD NOTHING rules are not supported for COPY](./do-instead-nothing-rules-are-not-supported-for-copy.md)
- [DO ALSO rules are not supported for data-modifying statements in WITH](./do-also-rules-are-not-supported-for-data-modifying-statements-in-with.md)
