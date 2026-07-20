---
message: "could not convert value of type %s to jsonpath"
slug: could-not-convert-value-of-type-to-jsonpath
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:3395"
reproduced: false
---

# `could not convert value of type %s to jsonpath`

## What it means

A value passed as a jsonpath variable could not be represented in the jsonpath type system. The `%s` names the source type. Jsonpath supports a limited set of value types, and this one is not among them.

## When it happens

It happens when the variables object of a jsonpath query (the `vars` argument to `jsonb_path_query` and friends) contains a value whose type has no jsonpath equivalent.

## How to fix

Pass jsonpath variables as JSON-compatible types — strings, numbers, booleans, or null. Convert unsupported values to one of these before building the variables object.

## Example

*Illustrative* — an unsupported variable type in a jsonpath query.

```sql
SELECT jsonb_path_query('{}', '$x', '{"x": ...}');
-- ERROR:  could not convert value of type ... to jsonpath
```

## Related

- [could not convert value to jsonb](./could-not-convert-value-to-jsonb.md)
- [could not convert type to](./could-not-convert-type-to.md)
