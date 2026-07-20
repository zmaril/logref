---
message: "could not decide what to do with file \"%s\""
slug: could-not-decide-what-to-do-with-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/filemap.c:914"
reproduced: false
---

# `could not decide what to do with file "%s"`

## What it means

`pg_rewind` compared the source and target for a file and could not classify what action to take on it. The `%s` names the file. This is an internal consistency check in the file-map builder.

## When it happens

It fires while `pg_rewind` builds its plan of which files to copy, keep, or remove, when a file's state on the two sides does not fit any expected combination.

## How to fix

This usually signals an unexpected difference between the two clusters or a manually altered data directory. Confirm the source and target are a valid rewind pair from a shared history and that neither data directory was modified by hand. Report a reproducible case if the clusters are genuinely a valid pair.

## Example

*Illustrative* — an unclassifiable file during rewind.

```text
pg_rewind: fatal: could not decide what to do with file "base/16384/2601"
```

## Related

- [could not close target file](./could-not-close-target-file.md)
- [could not create symbolic link at](./could-not-create-symbolic-link-at.md)
