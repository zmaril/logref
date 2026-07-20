---
message: "cannot specify both %s and %s"
slug: cannot-specify-both-and-9c5a12
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_INVALID_CURSOR_DEFINITION
    code: "42P11"
call_sites:
  - "postgres/src/backend/parser/analyze.c:3375"
  - "postgres/src/backend/parser/analyze.c:3383"
  - "postgres/src/bin/pg_verifybackup/pg_verifybackup.c:262"
reproduced: false
---

# `cannot specify both %s and %s`

## What it means

Two mutually exclusive options were given to the same command. The placeholders name the conflicting options. Some options contradict each other (or a cursor/query clause pair cannot coexist), so specifying both is rejected rather than silently ignoring one.

## When it happens

Passing two options that cannot be combined — for example conflicting cursor-definition clauses, or two command-line flags that set the same thing different ways.

## How to fix

Keep only the option that expresses your intent and remove the other. Consult the command's syntax to see which options are mutually exclusive, and choose one. If you need the behavior of both, the command likely does not support that combination — restructure the request.

## Example

*Illustrative* — two conflicting options together.

```text
ERROR:  cannot specify both SCROLL and NO SCROLL
```

## Related

- [and are mutually exclusive options](./and-are-mutually-exclusive-options.md)
- [and are incompatible options](./and-are-incompatible-options.md)
