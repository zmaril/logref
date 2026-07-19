---
message: "The target directory will not be modified."
slug: the-target-directory-will-not-be-modified
passthrough: false
api: [pg_log_info_detail]
level: [INFO]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2519"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:248"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:307"
reproduced: false
---

# `The target directory will not be modified.`

## What it means

An informational message from a backup or subscriber-setup tool, reassuring the operator that because of the mode it is running in — such as a dry run — it will leave the target directory untouched. It reports intent, not a problem.

## When it happens

Running pg_createsubscriber, pg_combinebackup, or a similar tool in a check or dry-run mode, where the tool reports what it would do without changing the target.

## Is this a problem?

No action is needed. It confirms the tool is running in a non-modifying mode. Run without the dry-run option when you want it to make the changes for real.

## Example

*Illustrative* — a dry-run reassurance.

```text
INFO:  The target directory will not be modified.
```

## Related

- [would create directory](./would-create-directory.md)
- [creating directory](./creating-directory.md)
