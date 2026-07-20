---
message: "ignoring file \"%s\" because no file \"%s\" exists"
slug: ignoring-file-because-no-file-exists
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/access/transam/xlogrecovery.c:667"
  - "postgres/src/backend/access/transam/xlogrecovery.c:673"
reproduced: false
---

# `ignoring file "%s" because no file "%s" exists`

## What it means

A log message that a file was ignored because a companion file it depends on does not exist.

## When it happens

It arises in paths that pair files (for example a data file and an expected sibling) when the sibling is missing, so the first file is skipped.

## Is this a problem?

Usually informational — the file is skipped safely. If the paired file should exist, investigate why it is missing; the message names both files so you can check the pairing.

## Example

*Illustrative* — ignoring a file with no companion.

```text
LOG:  ignoring file "a.tmp" because no file "a" exists
```

## Related

- [entry "%s" excluded from source file list](./entry-excluded-from-source-file-list.md)
- [manifest file "%s" contains no entry for file "%s"](./manifest-file-contains-no-entry-for-file.md)
