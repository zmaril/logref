---
message: "-c %s requires a value"
slug: c-requires-a-value
passthrough: false
api: [ereport, pg_log_error]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/bootstrap/bootstrap.c:297"
  - "postgres/src/backend/postmaster/postmaster.c:648"
  - "postgres/src/backend/tcop/postgres.c:4055"
  - "postgres/src/bin/initdb/initdb.c:3304"
reproduced: true
---

# `-c %s requires a value`

## What it means

A `-c` option (setting a configuration parameter) was given without its value. The placeholder is the parameter name. The `-c name=value` form requires the value; supplying just the name is rejected.

## When it happens

Starting the server or a bootstrap process with `-c name` and no `=value`, or a malformed `-c` argument that omits the value.

## How to fix

Write the option as `-c name=value` with no space around the `=`. Supply the intended value for the named parameter.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__69_scripts`); see the reproducer for the triggering workload. It emits:

```text
ERROR:  -c %s requires a value
```

## Related

- [requires a parameter](./requires-a-parameter.md)
- [and are mutually exclusive options](./and-are-mutually-exclusive-options.md)
