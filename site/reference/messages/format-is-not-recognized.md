---
message: "%s format is not recognized: \"%s\""
slug: format-is-not-recognized
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_SQL_JSON_DATETIME_FUNCTION
    code: "22031"
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2584"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2590"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2617"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2645"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2698"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2749"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2820"
reproduced: false
---

# `%s format is not recognized: "%s"`

## What it means

A SQL/JSON datetime function could not match a value against the datetime template it was given. The first placeholder is the template type/name, the second the offending value. The `.datetime()`/`.date()`/`.time()` jsonpath methods and related functions parse strings against a format, and the string did not fit.

## When it happens

`jsonb_path_query` with a `.datetime(template)` method whose input string does not match the template, or a SQL/JSON function given a datetime string in an unexpected shape. A mismatch between the actual string format and the specified template is the cause.

## How to fix

Make the template match the actual string format, or normalize the input strings to the template you use. Check the value against the template character by character — a different separator, order, or missing field breaks the match. For flexible input, pre-clean the strings or choose a template that fits them.

## Example

*Illustrative* — a datetime string that does not match its template.

```sql
SELECT jsonb_path_query('"2024/01/01"', '$.datetime("YYYY-MM-DD")');
```

Produces:

```text
ERROR:  date format is not recognized: "2024/01/01"
```

## Related

- [argument of jsonpath item method is invalid for type](./argument-of-jsonpath-item-method-is-invalid-for-type.md)
- [localized string format value too long](./localized-string-format-value-too-long.md)
