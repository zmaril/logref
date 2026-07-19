---
message: "conditional DO INSTEAD rules are not supported for COPY"
slug: conditional-do-instead-rules-are-not-supported-for-copy
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copyto.c:942"
reproduced: false
---

# `conditional DO INSTEAD rules are not supported for COPY`

## What it means

A `COPY` targeted a relation that has a conditional (`WHERE`-qualified) `DO INSTEAD` rule. `COPY` cannot honor conditional rewrite rules, so it refuses to run against such a relation.

## When it happens

It happens on `COPY ... TO`/`FROM` involving a table or view with a conditional `DO INSTEAD` rule.

## How to fix

Copy against the underlying table directly, use an unconditional `DO INSTEAD` rule, or replace the rule with a trigger. Alternatively perform the data movement with `INSERT ... SELECT` instead of `COPY`.

## Example

*Illustrative* — COPY against a conditionally-ruled relation.

```text
ERROR:  conditional DO INSTEAD rules are not supported for COPY
```

## Related

- [conditional DO INSTEAD rules are not supported for data-modifying statements in WITH](./conditional-do-instead-rules-are-not-supported-for-data-modifying-statements-in.md)
- [conditional utility statements are not implemented](./conditional-utility-statements-are-not-implemented.md)
