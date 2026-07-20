---
message: "could not open affix file \"%s\": %m"
slug: could-not-open-affix-file
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/src/backend/tsearch/spell.c:1233"
  - "postgres/src/backend/tsearch/spell.c:1304"
  - "postgres/src/backend/tsearch/spell.c:1453"
reproduced: false
---

# `could not open affix file "%s": %m`

## What it means

A text-search dictionary (an Ispell-type dictionary) could not open its affix file. The placeholders are the file path and the OS error. Ispell dictionaries need both a dictionary file and an affix file; the affix file could not be read at the path given.

## When it happens

Creating or using a `CREATE TEXT SEARCH DICTIONARY` of the Ispell template whose `AffFile` points at a missing file, a wrong name, or a file the server cannot read (permissions), typically under `$SHAREDIR/tsearch_data`.

## How to fix

Read the appended OS error. Place the affix file in the tsearch data directory (`$SHAREDIR/tsearch_data`), reference it by its base name without the `.affix` extension, and ensure the server OS user can read it. Confirm the file exists and the name/case matches the `AffFile` option.

## Example

*Illustrative* — a missing affix file for an Ispell dictionary.

```text
ERROR:  could not open affix file "/usr/share/postgresql/tsearch_data/x.affix": No such file or directory
```

## Related

- [could not open file](./could-not-open-file-c6e6a4.md)
- [word is too long to be indexed](./word-is-too-long-to-be-indexed.md)
