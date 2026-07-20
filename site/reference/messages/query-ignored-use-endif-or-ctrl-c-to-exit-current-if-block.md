---
message: "query ignored; use \\endif or Ctrl-C to exit current \\if block"
slug: query-ignored-use-endif-or-ctrl-c-to-exit-current-if-block
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/mainloop.c:459"
  - "postgres/src/bin/psql/mainloop.c:618"
reproduced: false
---

# `query ignored; use \endif or Ctrl-C to exit current \if block`

## What it means

A psql message. While inside a false branch of a `\if`/`\elif`/`\else` conditional block, psql skipped a query because that branch is not being executed, and reminds you how to leave the block.

## When it happens

It appears when running scripts (or interactively) with psql conditionals, and a statement sits in a branch whose condition is false, so psql does not send it to the server.

## How to fix

This is expected behavior inside an inactive conditional branch, not an error to fix. Close the block with `\endif` (or press Ctrl-C interactively). If the query should have run, check the `\if` condition that put you in the false branch.

## Example

*Illustrative* — a query skipped inside a false \if branch.

```text
query ignored; use \endif or Ctrl-C to exit current \if block
```

## Related

- [\pset: unknown option: %s](./pset-unknown-option.md)
- [query returned no rows](./query-returned-no-rows.md)
