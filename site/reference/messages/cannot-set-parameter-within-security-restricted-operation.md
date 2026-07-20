---
message: "cannot set parameter \"%s\" within security-restricted operation"
slug: cannot-set-parameter-within-security-restricted-operation
passthrough: false
api: [ereport]
level: [ERROR]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/utils/init/miscinit.c:673"
  - "postgres/src/backend/utils/misc/guc.c:3557"
reproduced: false
---

# `cannot set parameter "%s" within security-restricted operation`

## What it means

A `SET` of a configuration parameter was attempted inside a security-restricted operation — a context (such as index expression evaluation, a maintenance operation, or certain `SECURITY DEFINER` internals) where changing session settings could subvert the security boundary. The placeholder is the parameter name.

## When it happens

Code running in a security-restricted context issued a `SET` — for example a function used in an index expression, a trigger during a system operation, or logic invoked while Postgres has locked down settings to prevent privilege confusion.

## How to fix

Do not change configuration parameters from within such contexts. Move any needed `SET` outside the security-restricted operation, or set the parameter at the function or session level beforehand. Functions used in index expressions and similar positions must not alter session settings.

## Example

*Illustrative* — SET from within a restricted operation.

```text
ERROR:  cannot set parameter "search_path" within security-restricted operation
```

## Related

- [cannot set generated column](./cannot-set-generated-column.md)
- [cannot set system attribute](./cannot-set-system-attribute.md)
