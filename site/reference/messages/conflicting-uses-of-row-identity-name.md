---
message: "conflicting uses of row-identity name \"%s\""
slug: conflicting-uses-of-row-identity-name
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/appendinfo.c:924"
reproduced: false
---

# `conflicting uses of row-identity name "%s"`

## What it means

The planner found the same row-identity name used in conflicting ways while building append/inheritance mappings. This is an internal consistency check on how row identity is tracked across partitions or inheritance.

## When it happens

It fires during planning of statements over partitioned or inherited tables when the row-identity bookkeeping does not line up as expected.

## How to fix

This is an internal planner error, not a user setting. Capture the query and the table structure and report it; as a workaround, simplify the statement (for example avoid the specific inheritance/partition shape that triggers it) if you need to proceed.

## Example

*Illustrative* — an internal row-identity naming conflict.

```text
ERROR:  conflicting uses of row-identity name "x"
```

## Related

- [column of relation appears more than once](./column-of-relation-appears-more-than-once.md)
- [combining Aggref does not point to an Aggref](./combining-aggref-does-not-point-to-an-aggref.md)
