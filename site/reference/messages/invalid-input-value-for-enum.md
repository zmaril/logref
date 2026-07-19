---
message: "invalid input value for enum %s: \"%s\""
slug: invalid-input-value-for-enum
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TEXT_REPRESENTATION
    code: "22P02"
call_sites:
  - "postgres/src/backend/utils/adt/enum.c:192"
  - "postgres/src/backend/utils/adt/enum.c:202"
reproduced: false
---

# `invalid input value for enum %s: "%s"`

## What it means

A text value was cast to an enum type but is not one of that enum's defined labels. The placeholders name the enum type and the rejected value.

## When it happens

It arises when inserting or casting a string into an `enum` column whose set of labels does not include that string — a typo, a label that was never added, or case/whitespace differences.

## How to fix

Use one of the enum's existing labels, listed with `SELECT enum_range(NULL::your_enum);`. If the value is a legitimate new member, add it with `ALTER TYPE your_enum ADD VALUE 'label';`. Enum labels are case-sensitive and must match exactly.

## Example

*Illustrative* — a value outside the enum's labels.

```sql
SELECT 'purple'::rainbow;  -- not a label of enum rainbow
```

## Related

- [is not an existing enum label](./is-not-an-existing-enum-label.md)
- [is not an enum](./is-not-an-enum.md)
