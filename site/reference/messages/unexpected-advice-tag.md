---
message: "unexpected advice tag: %d"
slug: unexpected-advice-tag
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pg_plan_advice/pgpa_planner.c:800"
  - "postgres/contrib/pg_plan_advice/pgpa_planner.c:840"
reproduced: false
---

# `unexpected advice tag: %d`

## What it means

Internal error. Code reading an advice record encountered a tag value it does not recognize. The placeholder is the numeric tag. It is a self-check on a stored or streamed advice structure, associated with the `pg_stash` advice feature.

## When it happens

It fires when the advice reader hits an out-of-range tag — a sign of a corrupted or version-mismatched advice record rather than a user action.

## How to fix

This is an internal consistency guard for a specific feature. Treat the associated advice data as suspect; regenerate it through the feature rather than editing by hand, and report a reproducible case if it recurs.

## Example

*Illustrative* — an unrecognized advice tag.

```text
ERROR:  unexpected advice tag: 99
```

## Related

- [unexpected command tag "%s"](./unexpected-command-tag.md)
- [syntax error in file "%s" line %u: expected stash name](./syntax-error-in-file-line-expected-stash-name.md)
