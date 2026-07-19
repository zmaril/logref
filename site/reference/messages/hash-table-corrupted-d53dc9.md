---
message: "hash table \"%s\" corrupted"
slug: hash-table-corrupted-d53dc9
passthrough: false
api: [elog]
level: [FATAL, PANIC]
call_sites:
  - "postgres/src/backend/utils/hash/dynahash.c:1743"
  - "postgres/src/backend/utils/hash/dynahash.c:1745"
reproduced: false
---

# `hash table "%s" corrupted`

## What it means

Internal error. A dynamic hash table failed its integrity check. The `%s` is the table name. It is a data-structure consistency guard; at some sites it is raised as PANIC.

## When it happens

It fires when a shared or local hash table's bookkeeping is inconsistent, which usually reflects memory corruption from a bug in core code or an extension. It does not come from SQL or data.

## How to fix

This points at memory corruption. If extensions are loaded, suspect them. As a PANIC it stops the process; capture the backtrace and a reproduction and report it as a bug.

## Example

*Illustrative* — a hash table failed its integrity check.

```text
PANIC:  hash table "LOCK hash" corrupted
```

## Related

- [doubly linked list is corrupted](./doubly-linked-list-is-corrupted.md)
- [free page manager btree is corrupt](./free-page-manager-btree-is-corrupt.md)
