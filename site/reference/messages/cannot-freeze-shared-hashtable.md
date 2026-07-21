---
message: "cannot freeze shared hashtable \"%s\""
slug: cannot-freeze-shared-hashtable
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/hash/dynahash.c:1467"
reproduced: false
---

# `cannot freeze shared hashtable "%s"`

## What it means

An internal guard in the dynamic hash-table code fired: code tried to freeze a hash table that lives in shared memory. Freezing is only meaningful for a private, local hash table, so freezing a shared one is refused. The placeholder is the hash table name.

## When it happens

It is reached when a caller invokes the freeze operation on a shared-memory hash table. It reflects a coding issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the extension or code path that manages the hash table and report it, since only local hash tables may be frozen.

## Example

*Illustrative* — freeze attempted on a shared hash table.

```text
ERROR:  cannot freeze shared hashtable "LOCK hash"
```

## Related

- [cannot freeze hashtable because it has active scans](./cannot-freeze-hashtable-because-it-has-active-scans.md)
- [cannot insert into frozen hashtable](./cannot-insert-into-frozen-hashtable.md)
