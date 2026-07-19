---
message: "column exclusion constraints are not supported"
slug: column-exclusion-constraints-are-not-supported
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:932"
reproduced: false
---

# `column exclusion constraints are not supported`

## What it means

An internal guard fired: constraint-building code was asked to create an exclusion constraint at the single-column level where that form is not implemented. Exclusion constraints are defined at the table level, so this state should not occur.

## When it happens

It is reached from constraint construction in the server. It reflects an internal inconsistency rather than a supported user action.

## How to fix

There is no user-level fix. Define exclusion constraints with the table-level `EXCLUDE` syntax. If this appears from ordinary DDL, capture the statement and the server log and report it.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  column exclusion constraints are not supported
```

## Related

- [column does not exist](./column-does-not-exist-fb944f.md)
- [column appears twice in unique constraint](./column-appears-twice-in-unique-constraint.md)
