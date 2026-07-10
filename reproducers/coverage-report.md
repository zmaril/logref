# Reproducer coverage report

The Validate stage of LogRef (see `notes/design.md` §4): a HEAD build of
Postgres was driven through the scenarios in `reproducers/scenarios/`, its
`jsonlog` output captured, and each line's `file_name:file_line_num` joined
against the extracted catalog by `(basename, line)`.

- Postgres HEAD commit: `54cd6fc83176d7c03abf95554aef26b0b24acc7d`
- Catalog sites: **14806**
- Distinct sites reproduced (exact file:line): **243** (1.64%)
- Distinct sites reproduced (±3-line window): **275** (1.86%)
- Distinct captured call sites with no catalog match: 78

## Reproduced sites by severity

| level | sites hit |
|---|--:|
| ERROR | 152 |
| DEBUG1 | 27 |
| DEBUG2 | 19 |
| LOG | 12 |
| elevel | 11 |
| DEBUG3 | 7 |
| IsPostmasterEnvironment ? LOG : NOTICE | 3 |
| WARNING | 2 |
| DEBUG4 | 2 |
| ivinfo->message_level | 2 |
| verbose ? INFO : LOG | 2 |
| DEBUG5 | 1 |
| lev | 1 |
| INFO | 1 |
| throwError ? ERROR : WARNING | 1 |

## Top source files by sites reproduced

| file | hit | in catalog |
|---|--:|--:|
| `postgres/src/backend/postmaster/postmaster.c` | 14 | 91 |
| `postgres/src/backend/commands/tablecmds.c` | 13 | 521 |
| `postgres/src/backend/utils/adt/float.c` | 12 | 33 |
| `postgres/src/backend/utils/adt/int.c` | 7 | 35 |
| `postgres/src/backend/access/transam/xlog.c` | 7 | 140 |
| `postgres/src/backend/access/transam/xlogrecovery.c` | 7 | 115 |
| `postgres/src/backend/utils/adt/numeric.c` | 7 | 82 |
| `postgres/src/backend/access/transam/xact.c` | 6 | 73 |
| `postgres/src/backend/utils/adt/varlena.c` | 6 | 41 |
| `postgres/src/backend/utils/adt/jsonfuncs.c` | 6 | 58 |
| `postgres/src/backend/parser/parse_relation.c` | 5 | 63 |
| `postgres/src/backend/utils/misc/guc.c` | 5 | 107 |
| `postgres/src/backend/utils/adt/oracle_compat.c` | 5 | 10 |
| `postgres/src/backend/utils/adt/timestamp.c` | 5 | 147 |
| `postgres/src/backend/parser/parse_agg.c` | 4 | 21 |
| `postgres/src/backend/parser/analyze.c` | 4 | 72 |
| `postgres/src/backend/utils/adt/jsonpath_exec.c` | 4 | 96 |
| `postgres/src/backend/catalog/namespace.c` | 4 | 46 |
| `postgres/src/backend/parser/parse_expr.c` | 4 | 89 |
| `postgres/src/backend/commands/copy.c` | 4 | 57 |
| `postgres/src/backend/storage/ipc/ipc.c` | 4 | 11 |
| `postgres/src/backend/commands/repack.c` | 4 | 69 |
| `postgres/src/backend/utils/activity/pgstat.c` | 3 | 47 |
| `postgres/src/backend/catalog/index.c` | 3 | 66 |
| `postgres/src/backend/parser/parse_utilcmd.c` | 3 | 147 |

## Sample matches (captured jsonlog line -> catalog site)

- `postgres/src/backend/utils/adt/jsonb.c:1137` [ERROR/ERRCODE_INVALID_PARAMETER_VALUE] — argument list must have even number of elements
- `postgres/src/backend/catalog/pg_proc.c:402` [ERROR/ERRCODE_DUPLICATE_FUNCTION] — function "%s" already exists with same argument types
- `postgres/src/backend/parser/parse_agg.c:1572` [ERROR/ERRCODE_GROUPING_ERROR] — column "%s.%s" must appear in the GROUP BY clause or be used in an aggregate function
- `postgres/src/backend/utils/adt/datetime.c:3349` [ERROR/ERRCODE_INVALID_PARAMETER_VALUE] — time zone "%s" not recognized
- `postgres/src/backend/commands/portalcmds.c:198` [ERROR/ERRCODE_UNDEFINED_CURSOR] — cursor "%s" does not exist
- `postgres/src/backend/utils/adt/int8.c:936` [ERROR/ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE] — bigint out of range
- `postgres/src/backend/utils/activity/pgstat.c:1845` [DEBUG2/-] — reading stats file "%s"
- `postgres/src/backend/catalog/index.c:904` [ERROR/ERRCODE_DUPLICATE_TABLE] — relation "%s" already exists
- `postgres/src/backend/parser/parse_utilcmd.c:481` [DEBUG1/-] — %s will create implicit sequence "%s" for serial column "%s.%s"
- `postgres/src/backend/commands/user.c:1758` [ERROR/ERRCODE_INVALID_GRANT_OPERATION] — role "%s" is a member of role "%s"
- `postgres/src/backend/utils/adt/int.c:942` [ERROR/ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE] — smallint out of range
- `postgres/src/backend/commands/prepare.c:295` [ERROR/ERRCODE_SYNTAX_ERROR] — wrong number of parameters for prepared statement "%s"
