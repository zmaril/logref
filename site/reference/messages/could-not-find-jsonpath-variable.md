---
message: "could not find jsonpath variable \"%s\""
slug: could-not-find-jsonpath-variable
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:3429"
reproduced: false
---

# `could not find jsonpath variable "%s"`

## What it means

A jsonpath expression referenced a variable that was not supplied in the query's variables object. The `%s` gives the variable name. The named variable has no value to substitute.

## When it happens

It happens with `jsonb_path_query` and related functions when the path uses `$name` but the `vars` argument does not contain a matching key.

## How to fix

Provide every variable the path references in the `vars` JSON object, matching names exactly. Check for typos and make sure the variables object includes each `$`-prefixed name used in the path.

## Example

*Illustrative* — a path variable missing from vars.

```sql
SELECT jsonb_path_query('{"a":1}', '$.a > $threshold', '{}');
-- ERROR:  could not find jsonpath variable "threshold"
```

## Related

- [could not convert value of type to jsonpath](./could-not-convert-value-of-type-to-jsonpath.md)
- [could not determine row type for result of](./could-not-determine-row-type-for-result-of.md)
