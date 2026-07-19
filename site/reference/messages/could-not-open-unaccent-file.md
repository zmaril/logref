---
message: "could not open unaccent file \"%s\": %m"
slug: could-not-open-unaccent-file
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/contrib/unaccent/unaccent.c:106"
reproduced: false
---

# `could not open unaccent file "%s": %m`

## What it means

The `unaccent` text-search dictionary tried to open its rules file and the operating system refused. The `%m` reason gives the cause. The rules file maps accented characters to their unaccented forms.

## When it happens

It happens while creating or using an `unaccent` dictionary, when its rules file is missing, misnamed, or unreadable — often a wrong name in the dictionary definition or a file not installed in `$SHAREDIR/tsearch_data`.

## How to fix

Confirm the `unaccent` rules file exists in the text-search data directory with the expected name and is readable by the server. Correcting the name in the dictionary definition, or installing the file, resolves it.

## Example

*Illustrative* — a missing unaccent rules file.

```text
ERROR:  could not open unaccent file "/usr/share/postgresql/tsearch_data/unaccent.rules": No such file or directory
```

## Related

- [could not open thesaurus file](./could-not-open-thesaurus-file.md)
- [could not open stop-word file](./could-not-open-stop-word-file.md)
