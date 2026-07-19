---
message: "%s requires a parameter"
slug: requires-a-parameter
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/define.c:37"
  - "postgres/src/backend/commands/define.c:241"
  - "postgres/src/backend/commands/define.c:273"
  - "postgres/src/backend/commands/define.c:301"
  - "postgres/src/backend/commands/define.c:347"
reproduced: false
---

# `%s requires a parameter`

## What it means

A definition option that must carry a value was given without one. The placeholder is the option name. Statements like `CREATE`/`ALTER` with `WITH (...)` option lists, and `DefineXxx` code paths, require certain options to be written as `name = value`.

## When it happens

Writing an option that needs a value as a bare keyword — for example `WITH (fillfactor)` instead of `WITH (fillfactor = 70)` — or omitting the value in an operator/type/aggregate definition option that requires one.

## How to fix

Supply the option's value with `option = value`. Consult the command's option list for which options are flags and which require a value, and provide the value for the named option.

## Example

*Illustrative* — an option missing its value.

```sql
CREATE TABLE t (a int) WITH (fillfactor);
```

## Related

- [and are mutually exclusive options](./and-are-mutually-exclusive-options.md)
- [requires a value](./c-requires-a-value.md)
