---
message: "error while copying relation \"%s.%s\": could not read file \"%s\": %m"
slug: error-while-copying-relation-could-not-read-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/file.c:106"
reproduced: false
---

# `error while copying relation "%s.%s": could not read file "%s": %m`

## What it means

`pg_upgrade` was copying a relation's data file from the old cluster into the new one and the read failed. The placeholders name the schema-qualified relation, the source file, and the operating-system error.

## When it happens

It fires during the `pg_upgrade` copy phase (the default transfer mode) when the old cluster's segment file cannot be read — for example a permissions problem, an I/O error on the source disk, or a file that was removed or truncated out from under the upgrade.

## How to fix

Read the trailing operating-system error for the specific cause. Confirm the old data directory is intact and readable by the user running `pg_upgrade`, that no other server is running against it, and that the source disk is healthy. Fix the underlying access or hardware problem and re-run the upgrade; a failed `pg_upgrade` leaves the old cluster usable.

## Example

*Illustrative* — the source segment is unreadable.

```
error while copying relation "public.orders": could not read file "/old/base/16384/24576": Input/output error
```

## Related

- [error while copying relation ... could not write file](./error-while-copying-relation-could-not-write-file.md)
- [error while copying relation ... (to)](./error-while-copying-relation-to.md)
