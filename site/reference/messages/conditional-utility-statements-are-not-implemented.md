---
message: "conditional utility statements are not implemented"
slug: conditional-utility-statements-are-not-implemented
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteManip.c:1172"
reproduced: false
---

# `conditional utility statements are not implemented`

## What it means

A rule attempted to rewrite a utility (DDL-style) statement conditionally. The rule system does not support conditional handling of utility statements, so the rewrite is rejected.

## When it happens

It happens when a `DO INSTEAD` rule with a condition would apply to a utility command rather than a plain `SELECT`/`INSERT`/`UPDATE`/`DELETE`.

## How to fix

Redesign the rule so it does not conditionally rewrite utility statements. Use an unconditional rule, a trigger, or application logic to achieve the intended behavior.

## Example

*Illustrative* — a conditional rule over a utility statement.

```text
ERROR:  conditional utility statements are not implemented
```

## Related

- [conditional DO INSTEAD rules are not supported for COPY](./conditional-do-instead-rules-are-not-supported-for-copy.md)
- [conditional DO INSTEAD rules are not supported for data-modifying statements in WITH](./conditional-do-instead-rules-are-not-supported-for-data-modifying-statements-in.md)
