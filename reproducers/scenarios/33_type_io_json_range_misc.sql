-- jsonpath parser, multirange/range literals, array limits, records, reg* and domains  ->  src/backend/utils/adt/{jsonpath,jsonpath_scan,jsonpath_exec,multirangetypes,rangetypes,json,jsonb,jsonfuncs,arrayfuncs,rowtypes,regproc,domains,enum}.c
-- Focuses on parser-internal and structural value errors: malformed jsonpath
-- programs, malformed multirange/range literals, dimension limits, malformed
-- composite literals, the reg* input-function family, and domain/enum checks.

-- Self-contained objects this file casts into (public schema, io_-prefixed).
DROP TYPE IF EXISTS io_rowt CASCADE;
CREATE TYPE io_rowt AS (a int, b text);
DROP DOMAIN IF EXISTS io_posint CASCADE;
CREATE DOMAIN io_posint AS int CHECK (VALUE > 0);
DROP DOMAIN IF EXISTS io_notnull CASCADE;
CREATE DOMAIN io_notnull AS int NOT NULL;
DROP DOMAIN IF EXISTS io_d2 CASCADE;
CREATE DOMAIN io_d2 AS io_posint CHECK (VALUE < 100);
DROP TYPE IF EXISTS io_grade CASCADE;
CREATE TYPE io_grade AS ENUM ('A', 'B', 'C');

-- jsonpath parser: unterminated tokens, bad range, bad flag, bad escape (jsonpath.c / jsonpath_scan.l)
SELECT '$.a['::jsonpath;
SELECT '$."abc'::jsonpath;
SELECT '$ ? (@ == "x)'::jsonpath;
SELECT '$.**{2 to 1}'::jsonpath;
SELECT '$.**{-1}'::jsonpath;
SELECT '$ ? (@ like_regex "a" flag "q")'::jsonpath;
SELECT '$."a\q"'::jsonpath;
SELECT '$[1 to ]'::jsonpath;

-- jsonpath execution: strict structural, method type/overflow, division (jsonpath_exec.c)
SELECT jsonb_path_query('[1,2]', 'strict $[5]');
SELECT jsonb_path_query('"x"', 'strict $[0]');
SELECT jsonb_path_query('1', 'strict $.size()');
SELECT jsonb_path_query('"x"', '$.abs()');
SELECT jsonb_path_query('"x"', '$.floor()');
SELECT jsonb_path_query('"x"', '$.ceiling()');
SELECT jsonb_path_query('"NaN"', '$.double()');
SELECT jsonb_path_query('"1e10000"', '$.double()');
SELECT jsonb_path_query('1', '$.keyvalue()');
SELECT jsonb_path_query('1', '$ / 0');

-- malformed multirange literals (multirangetypes.c multirange_in, no baseline coverage)
SELECT '{[1,2]'::int4multirange;
SELECT '{[1,2] [3,4]}'::int4multirange;
SELECT 'x{[1,2]}'::int4multirange;
SELECT '{[1,2]} x'::int4multirange;
SELECT '{[1,2],}'::int4multirange;
SELECT 'notmultirange'::int4multirange;

-- malformed range literals: unexpected end, junk before/after, too many commas (rangetypes.c range_parse)
SELECT '[1,2'::int4range;
SELECT 'x[1,2)'::int4range;
SELECT '[1,2) x'::int4range;
SELECT '[1,2,3]'::int4range;

-- json/jsonb value construction and path errors (json.c, jsonb.c, jsonfuncs.c)
SELECT to_jsonb('NaN'::float8);
SELECT to_jsonb('Infinity'::float8);
SELECT to_json('-Infinity'::float8);
SELECT jsonb_build_object(ARRAY[1,2], 3);
SELECT jsonb_set('[0,1]', '{-9}', '9');
SELECT jsonb_insert('[0,1]', '{-9}', '9');
SELECT json_to_record('{"a":[1,2]}') AS x(a int);
SELECT to_jsonb(1) #- '{a}';

-- array dimension and size limits (arrayfuncs.c / array_userfuncs.c)
SELECT '{{{{{{{1}}}}}}}'::int[];
SELECT array_fill(0, ARRAY[1,1,1,1,1,1,1]);
SELECT '[1:2147483647]={1}'::int[];
SELECT trim_array('{1,2,3}'::int[], -1);
SELECT array_reverse('{{1,2},{3,4}}'::int[]);

-- malformed composite/record literals over a 2-column type (rowtypes.c record_in)
SELECT '(1,2'::io_rowt;
SELECT 'x(1,2)'::io_rowt;
SELECT '(1,2) x'::io_rowt;
SELECT '(1,2,3)'::io_rowt;
SELECT '(1)'::io_rowt;

-- reg* input functions: does-not-exist / syntax across the family (regproc.c)
SELECT 'nonesuch'::regprocedure;
SELECT 'pg_catalog.nonesuch(int)'::regprocedure;
SELECT 'nonesuch'::regnamespace;
SELECT 'nonesuch'::regrole;
SELECT '||||'::regoper;
SELECT '#(int,int)'::regoperator;
SELECT 'nonesuch.nonesuch'::regconfig;
SELECT 'nonesuch'::regdictionary;
SELECT '1(int)'::regprocedure;
SELECT 'a.b.c.d'::regproc;
SELECT 'nonesuch'::regcollation;

-- domain constraint violations at runtime cast (domains.c)
SELECT (-5)::io_posint;
SELECT NULL::io_notnull;
SELECT 200::io_d2;
SELECT (ARRAY[-1,2])::io_posint[];

-- invalid enum label (enum.c enum_in)
SELECT 'aardvark'::io_grade;
SELECT enum_range('A'::io_grade, 'nonesuch'::text::io_grade);
