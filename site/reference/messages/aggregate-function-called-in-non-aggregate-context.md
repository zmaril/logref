---
message: "aggregate function called in non-aggregate context"
slug: aggregate-function-called-in-non-aggregate-context
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/array_userfuncs.c:610"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:798"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:986"
  - "postgres/src/backend/utils/adt/bool.c:330"
  - "postgres/src/backend/utils/adt/numeric.c:4788"
  - "postgres/src/backend/utils/adt/numeric.c:5012"
  - "postgres/src/backend/utils/adt/numeric.c:5104"
  - "postgres/src/backend/utils/adt/numeric.c:5177"
  - "postgres/src/backend/utils/adt/numeric.c:5228"
  - "postgres/src/backend/utils/adt/numeric.c:5287"
  - "postgres/src/backend/utils/adt/numeric.c:5342"
  - "postgres/src/backend/utils/adt/numeric.c:5452"
  - "postgres/src/backend/utils/adt/numeric.c:5568"
  - "postgres/src/backend/utils/adt/numeric.c:5636"
  - "postgres/src/backend/utils/adt/numeric.c:5669"
  - "postgres/src/backend/utils/adt/numeric.c:5729"
  - "postgres/src/backend/utils/adt/numeric.c:5773"
  - "postgres/src/backend/utils/adt/numeric.c:5803"
  - "postgres/src/backend/utils/adt/numeric.c:6487"
  - "postgres/src/backend/utils/adt/timestamp.c:3993"
  - "postgres/src/backend/utils/adt/timestamp.c:4136"
  - "postgres/src/backend/utils/adt/timestamp.c:4173"
  - "postgres/src/backend/utils/adt/varlena.c:4394"
reproduced: false
---

# `aggregate function called in non-aggregate context`

## What it means

Internal error. An aggregate's transition or final function was invoked outside a real aggregation context, so it could not find the aggregate state it needs. User SQL normally cannot express this; it indicates a function being called in a way its C implementation does not support.

## When it happens

Calling an aggregate support function directly (for example invoking an internal transition function by name), or a bug in an extension that calls aggregate internals without setting up the aggregate context. Normal `GROUP BY`/window usage does not trigger it.

## How to fix

Do not call aggregate transition/final functions directly — use the aggregate through normal SQL. If an extension raises it, that extension is misusing the aggregate machinery and should be fixed or reported. Check whether a recent extension or custom function is invoking aggregate internals.

## Example

*Illustrative* — an internal aggregate function called directly.

```sql
SELECT float8_accum('{0,0,0}', 1.0);
```

Produces:

```text
ERROR:  aggregate function called in non-aggregate context
```

## Related

- [set-valued function called in context that cannot accept a set](./set-valued-function-called-in-context-that-cannot-accept-a-set.md)
- [materialize mode required, but it is not allowed in this context](./materialize-mode-required-but-it-is-not-allowed-in-this-context.md)
