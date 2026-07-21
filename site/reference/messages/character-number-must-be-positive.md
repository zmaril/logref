---
message: "character number must be positive"
slug: character-number-must-be-positive
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/oracle_compat.c:1043"
reproduced: false
---

# `character number must be positive`

## What it means

A function that takes a character position was given a value of zero or a negative number. Character positions are counted from one, so a non-positive index is not valid.

## When it happens

It occurs in functions that accept a position argument, such as certain text or encoding routines, when the supplied index is zero or negative.

## How to fix

Pass a position of one or greater. Adjust the calling expression so the index is a positive value.

## Example

*Illustrative* — a non-positive character position.

```text
ERROR:  character number must be positive
```

## Related

- [channel name cannot be empty](./channel-name-cannot-be-empty.md)
- [column definition lists can have at most entries](./column-definition-lists-can-have-at-most-entries.md)
