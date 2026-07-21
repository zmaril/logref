---
message: "argument \"%s\" of jsonpath item method .%s() is invalid for type %s"
slug: argument-of-jsonpath-item-method-is-invalid-for-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NON_NUMERIC_SQL_JSON_ITEM
    code: "22036"
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1201"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1227"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1313"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1338"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1389"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1409"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1470"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1547"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1579"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1603"
reproduced: true
---

# `argument "%s" of jsonpath item method .%s() is invalid for type %s`

## What it means

A SQL/JSON path method (like `.double()`, `.number()`, `.datetime()`) was applied to a JSON item whose type it cannot process. The placeholders are the argument, the method name, and the type. The method expects a certain JSON value kind and got another.

## When it happens

`jsonb_path_query` and related functions with a jsonpath that calls a numeric or datetime method on a non-numeric/non-string item — for example `.double()` on a JSON object or boolean, or `.datetime()` on a value that is not a valid formatted string.

## How to fix

Apply the method only to items of the appropriate JSON type — filter with a type predicate (`.type() == "number"`) or restructure the path so the method sees a compatible value. For `.datetime()`, ensure the item is a correctly formatted string. Validate the JSON shape the path traverses.

## Example

*Reproduced* — captured from `reproducers/scenarios/19_json_sqljson.sql`.

```sql
SELECT jsonb_path_query('"abc"', '$.bigint()');
```

Produces:

```text
ERROR:  argument "abc" of jsonpath item method .bigint() is invalid for type bigint
```

## Related

- [%s format is not recognized](./format-is-not-recognized.md)
- [could not determine input data type](./could-not-determine-input-data-type.md)
