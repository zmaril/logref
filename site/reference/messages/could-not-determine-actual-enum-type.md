---
message: "could not determine actual enum type"
slug: could-not-determine-actual-enum-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/enum.c:449"
  - "postgres/src/backend/utils/adt/enum.c:478"
  - "postgres/src/backend/utils/adt/enum.c:518"
  - "postgres/src/backend/utils/adt/enum.c:538"
reproduced: false
---

# `could not determine actual enum type`

## What it means

A function using the polymorphic `anyenum` pseudo-type could not resolve which concrete enum type its result should be. The placeholder-free text means the enum type could not be inferred from the arguments in the call context.

## When it happens

Calling a polymorphic enum-returning function (like `enum_first`/`enum_last` with a null argument, or `enum_range`) in a way that gives Postgres no concrete enum value to determine the type from.

## How to fix

Give the function a concrete enum value so the type is determined — for example pass `NULL::my_enum` instead of a bare `NULL`, or supply an actual enum-typed argument. Casting a null to the specific enum type resolves the polymorphism.

## Example

*Illustrative* — an unresolvable anyenum call.

```sql
SELECT enum_first(NULL);
```

## Related

- [could not determine polymorphic type](./could-not-determine-polymorphic-type.md)
- [argument declared is not consistent with argument declared](./argument-declared-is-not-consistent-with-argument-declared.md)
