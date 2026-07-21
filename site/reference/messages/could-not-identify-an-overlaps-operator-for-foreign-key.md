---
message: "could not identify an overlaps operator for foreign key"
slug: could-not-identify-an-overlaps-operator-for-foreign-key
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:10511"
reproduced: false
---

# `could not identify an overlaps operator for foreign key`

## What it means

A temporal foreign key (`FOREIGN KEY ... PERIOD`) needs an overlaps operator for the period column's type so it can check that the referencing range is covered by referenced rows, and no such operator was found.

## When it happens

It fires while creating a temporal foreign key, when the period column's range type has no registered overlaps (`&&`) operator — usually a custom or unusual range type without the operator support temporal keys require.

## How to fix

Use a range type that provides the overlaps operator for the temporal foreign key's period column. For a custom range type, add the `&&` overlaps operator (and the rest of the range operator class) so temporal constraints can be built on it.

## Example

*Illustrative* — a temporal FK on a type with no overlaps operator.

```text
ERROR:  could not identify an overlaps operator for foreign key
```

## Related

- [could not identify an intersect function for type](./could-not-identify-an-intersect-function-for-type.md)
- [could not identify relation associated with constraint](./could-not-identify-relation-associated-with-constraint.md)
