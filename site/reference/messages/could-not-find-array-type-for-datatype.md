---
message: "could not find array type for datatype %s"
slug: could-not-find-array-type-for-datatype
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/plan/subselect.c:431"
reproduced: false
---

# `could not find array type for datatype %s`

## What it means

The planner needed the array type that corresponds to a scalar data type and could not find one. The `%s` names the type. This is an internal guard: types used this way are expected to have an array type.

## When it happens

It fires while the planner rewrites a subquery into an array-based form and the element type has no registered array type. Ordinary built-in types always have one, so reaching it points at an unusual custom type.

## How to fix

This is an internal error. If a custom type is involved, make sure it was created with a corresponding array type (which `CREATE TYPE` normally does automatically). Note the type and query and report a reproducible case if it recurs.

## Example

*Illustrative* — a type with no array type during planning.

```text
ERROR:  could not find array type for datatype mytype
```

## Related

- [could not find element type for data type](./could-not-find-element-type-for-data-type.md)
- [could not find cast from to](./could-not-find-cast-from-to.md)
