---
message: "Try \"%s --help\" for more information.\n"
slug: try-help-for-more-information-5b6287
passthrough: false
api: [write_stderr]
level: [varies]
call_sites:
  - "postgres/src/backend/bootstrap/bootstrap.c:337"
  - "postgres/src/backend/postmaster/postmaster.c:768"
  - "postgres/src/backend/postmaster/postmaster.c:781"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1967"
reproduced: false
---

# `Try "%s --help" for more information.
`

## What it means

A command-line tool printed its standard hint pointing at `--help` after rejecting the invocation. The placeholder is the program name. It is not an error in itself — it is the second line a tool emits after a usage problem (an unknown option, a missing argument), telling the user where to find the full option list.

## When it happens

Invoking a Postgres command-line program with a bad or missing argument. The preceding line states the actual problem; this line is the follow-up hint.

## Is this a problem?

Read the line above this one — it names the real usage error — then run the program with `--help` to see the correct options and arguments, and re-invoke it correctly. This line alone is only a pointer.

## Example

*Illustrative* — the usage hint after a bad option.

```text
psql: error: unrecognized option '--frobnicate'
Try "psql --help" for more information.
```

## Related

- [unrecognized option](./unrecognized-option-973965.md)
- [could not parse](./could-not-parse.md)
