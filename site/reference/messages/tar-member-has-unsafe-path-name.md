---
message: "tar member has unsafe path name: \"%s\""
slug: tar-member-has-unsafe-path-name
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/fe_utils/astreamer_file.c:222"
  - "postgres/src/fe_utils/astreamer_tar.c:309"
reproduced: false
---

# `tar member has unsafe path name: "%s"`

## What it means

While reading a tar archive (for example during a base backup or restore), an entry had a path name considered unsafe — such as an absolute path or one that escapes the target directory with `..`. The placeholder is the offending name. Extracting it could write outside the intended location.

## When it happens

It arises in tools like `pg_basebackup`/`pg_verifybackup` or server-side tar handling when an archive contains a member whose path would traverse outside the extraction directory — a corrupted, malicious, or malformed archive.

## How to fix

Do not trust the archive. Re-create the backup from a trusted source, and verify the pipeline that produced the tar did not corrupt or tamper with member names. Postgres refuses the unsafe path deliberately; there is no override for extracting outside the target.

## Example

*Illustrative* — a tar member with a path-traversal name.

```text
FATAL:  tar member has unsafe path name: "../../etc/passwd"
```

## Related

- [program "%s" failed](./program-failed.md)
- [undefined file type for "%s"](./undefined-file-type-for.md)
