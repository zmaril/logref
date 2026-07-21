-- CREATE/DROP of functions, aggregates, operators and function-referencing
-- types; routine definition and catalog validation.
--   Function creation/validation -> src/backend/commands/functioncmds.c
--   Operator creation            -> src/backend/commands/operatorcmds.c
--   Aggregate command checks     -> src/backend/commands/aggregatecmds.c
--   Aggregate catalog checks     -> src/backend/catalog/pg_aggregate.c
--   Procedure/function catalog   -> src/backend/catalog/pg_proc.c
--   Operator catalog             -> src/backend/catalog/pg_operator.c
--   CREATE TYPE function refs    -> src/backend/commands/typecmds.c
--   Routine name resolution      -> src/backend/parser/parse_func.c

-- Unknown / unsupported language.
CREATE FUNCTION repro.f_lang() RETURNS int LANGUAGE nosuchlang AS 'x';
-- Conflicting / duplicate volatility and other option clauses.
CREATE FUNCTION repro.f_vol() RETURNS int LANGUAGE sql IMMUTABLE VOLATILE AS 'SELECT 1';
CREATE FUNCTION repro.f_dup() RETURNS int LANGUAGE sql LANGUAGE sql AS 'SELECT 1';
CREATE FUNCTION repro.f_strict() RETURNS int LANGUAGE sql STRICT CALLED ON NULL INPUT AS 'SELECT 1';
-- Return type mismatch in an inline SQL-standard function body.
CREATE FUNCTION repro.f_ret() RETURNS int LANGUAGE sql BEGIN ATOMIC SELECT 'x'::text; END;
-- Default before a non-default parameter.
CREATE FUNCTION repro.f_def(a int DEFAULT 1, b int) RETURNS int LANGUAGE sql AS 'SELECT 1';
-- Duplicate parameter name.
CREATE FUNCTION repro.f_pdup(a int, a int) RETURNS int LANGUAGE sql AS 'SELECT 1';
-- Function result type inferred from multiple OUT parameters conflicts with RETURNS.
CREATE FUNCTION repro.f_outconf(OUT a int, OUT b int) RETURNS int LANGUAGE sql AS 'SELECT 1, 2';
-- No result type at all (no RETURNS and no OUT parameter).
CREATE FUNCTION repro.f_nort(int) LANGUAGE sql AS 'SELECT 1';
-- No function body specified.
CREATE FUNCTION repro.f_nobody() RETURNS int LANGUAGE sql;
-- No language specified.
CREATE FUNCTION repro.f_nolang() RETURNS int AS 'SELECT 1';
-- Inline SQL-standard body with a non-SQL language.
CREATE FUNCTION repro.f_inline() RETURNS int LANGUAGE internal BEGIN ATOMIC SELECT 1; END;
-- More than one AS item for a language that needs only one.
CREATE FUNCTION repro.f_2as() RETURNS int LANGUAGE sql AS 'a', 'b';
-- COST / ROWS validation at CREATE time.
CREATE FUNCTION repro.f_rows() RETURNS SETOF int LANGUAGE sql ROWS -1 AS 'SELECT 1';
-- COST / ROWS validation on ALTER FUNCTION (a distinct set of call sites).
CREATE FUNCTION repro.altfn() RETURNS int LANGUAGE sql AS 'SELECT 1';
CREATE FUNCTION repro.srf() RETURNS SETOF int LANGUAGE sql AS 'SELECT 1';
ALTER FUNCTION repro.altfn() COST -1;
ALTER FUNCTION repro.srf() ROWS -1;
ALTER FUNCTION repro.altfn() ROWS 100;
-- PARALLEL clause with an invalid value.
CREATE FUNCTION repro.f_par() RETURNS int LANGUAGE sql PARALLEL bogus AS 'SELECT 1';
-- SUPPORT clause referencing a non-existent function.
CREATE FUNCTION repro.f_sup(int) RETURNS int LANGUAGE sql SUPPORT nosuchsupportfn AS 'SELECT 1';
-- VARIADIC parameter that is not the last parameter.
CREATE FUNCTION repro.f_var(VARIADIC a int[], b int) RETURNS int LANGUAGE sql AS 'SELECT 1';
-- SETOF used as a function / procedure argument.
CREATE FUNCTION repro.f_setarg(SETOF int) RETURNS int LANGUAGE sql AS 'SELECT 1';
CREATE PROCEDURE repro.p_setarg(SETOF int) LANGUAGE sql AS 'SELECT 1';
-- VARIADIC parameter followed by an OUT parameter.
CREATE PROCEDURE repro.p_var(VARIADIC a int[], OUT b int) LANGUAGE sql AS 'SELECT 1';
-- Default value on an OUT parameter.
CREATE FUNCTION repro.f_outdef(OUT a int DEFAULT 1) RETURNS int LANGUAGE sql AS 'SELECT 1';
-- Column / table reference inside a parameter default expression.
CREATE FUNCTION repro.f_tref(a int DEFAULT repro.parent.id) RETURNS int LANGUAGE sql AS 'SELECT 1';
-- Procedure OUT parameter appearing after a parameter with a default value.
CREATE PROCEDURE repro.p_outdef(IN a int DEFAULT 1, OUT b int) LANGUAGE sql AS 'SELECT 1';
-- SQL function with a pseudo-type argument / result.
CREATE FUNCTION repro.f_argcstr(cstring) RETURNS int LANGUAGE sql AS 'SELECT 1';
CREATE FUNCTION repro.f_retcstr() RETURNS cstring LANGUAGE sql AS 'SELECT NULL';
-- LEAKPROOF requires superuser: attempt as lowpriv.
SET ROLE lowpriv;
CREATE FUNCTION repro.f_leak() RETURNS int LANGUAGE sql LEAKPROOF AS 'SELECT 1';
RESET ROLE;
-- Polymorphic-result functions with no polymorphic argument.
CREATE FUNCTION repro.f_poly1() RETURNS anyelement LANGUAGE sql AS 'SELECT 1';
CREATE FUNCTION repro.f_poly2(int) RETURNS anyarray LANGUAGE sql AS 'SELECT ARRAY[1]';
CREATE FUNCTION repro.f_poly3(anyelement) RETURNS anyrange LANGUAGE sql AS 'SELECT NULL';
-- anycompatible family: result type not resolvable from arguments.
CREATE FUNCTION repro.f_poly4(int) RETURNS anycompatible LANGUAGE sql AS 'SELECT 1';
-- Functions referencing a shell (not-yet-defined) type.
CREATE TYPE repro.shell1;
CREATE FUNCTION repro.f_shellret() RETURNS repro.shell1 LANGUAGE sql AS 'SELECT NULL';
CREATE FUNCTION repro.f_shellarg(repro.shell1) RETURNS int LANGUAGE sql AS 'SELECT 1';

-- DO with a language that does not support inline code execution.
DO LANGUAGE sql $$ SELECT 1 $$;

-- CREATE CAST validation (cast function shape / physical compatibility).
CREATE CAST (int AS text) WITH FUNCTION now();
CREATE CAST (int AS int) WITH FUNCTION max(int);
CREATE CAST (int AS int) WITH FUNCTION generate_series(int, int);
CREATE CAST (bool AS int) WITH FUNCTION abs(int);
CREATE CAST (int AS bool) WITH FUNCTION abs(int);
CREATE CAST (int AS point) WITHOUT FUNCTION;
CREATE CAST (anyelement AS int) WITHOUT FUNCTION;
CREATE CAST (int AS anyelement) WITHOUT FUNCTION;

-- CREATE AGGREGATE: missing / invalid state function.
CREATE AGGREGATE repro.badagg1(int) (SFUNC = nosuchfn, STYPE = int);
-- CREATE AGGREGATE: sfunc exists but signature does not match stype.
CREATE AGGREGATE repro.badagg2(int) (SFUNC = int4pl, STYPE = text);
-- CREATE AGGREGATE: missing required STYPE.
CREATE AGGREGATE repro.badagg3(int) (SFUNC = int4pl);
-- CREATE AGGREGATE: missing SFUNC entirely.
CREATE AGGREGATE repro.badagg4(int) (STYPE = int);
-- CREATE AGGREGATE: unknown option.
CREATE AGGREGATE repro.badagg5(int) (SFUNC = int4pl, STYPE = int, NOSUCHOPT = 1);
-- CREATE AGGREGATE: HYPOTHETICAL on a non-ordered-set aggregate.
CREATE AGGREGATE repro.agg_hyp(int) (SFUNC = int4pl, STYPE = int, HYPOTHETICAL);
-- CREATE AGGREGATE: moving-aggregate option rules.
CREATE AGGREGATE repro.agg_ms(int) (SFUNC = int4pl, STYPE = int, MSTYPE = int);
CREATE AGGREGATE repro.agg_minv(int) (SFUNC = int4pl, STYPE = int, MINVFUNC = int4mi);
-- CREATE AGGREGATE: BASETYPE redundant with a function-style argument list.
CREATE AGGREGATE repro.agg_bt(int) (BASETYPE = int, SFUNC = int4pl, STYPE = int);
-- CREATE AGGREGATE: pseudo-type transition type.
CREATE AGGREGATE repro.agg_tt(int) (SFUNC = int4pl, STYPE = cstring);
-- CREATE AGGREGATE: shell-type / set-type input argument.
CREATE AGGREGATE repro.agg_shell(repro.shell1) (SFUNC = int4pl, STYPE = int);
CREATE AGGREGATE repro.agg_set(SETOF int) (SFUNC = int4pl, STYPE = int);
-- CREATE AGGREGATE: transition function exists but returns the wrong type.
CREATE AGGREGATE repro.agg_tr(int) (SFUNC = int4eq, STYPE = int);
-- CREATE AGGREGATE: combine function exists but returns the wrong type.
CREATE AGGREGATE repro.agg_comb(int) (SFUNC = int4pl, STYPE = int, COMBINEFUNC = int4eq);
-- CREATE AGGREGATE: serialization function without an internal transition type.
CREATE AGGREGATE repro.agg_ser(int) (SFUNC = int4pl, STYPE = int, SERIALFUNC = numeric_send);
-- CREATE AGGREGATE: invalid PARALLEL value.
CREATE AGGREGATE repro.agg_par(int) (SFUNC = int4pl, STYPE = int, PARALLEL = bogus);

-- CREATE OPERATOR: missing procedure.
CREATE OPERATOR repro.@@@ (LEFTARG = int, RIGHTARG = int);
-- CREATE OPERATOR: procedure does not exist.
CREATE OPERATOR repro.@@@ (LEFTARG = int, RIGHTARG = int, PROCEDURE = nosuchfn);
-- CREATE OPERATOR: no leftarg and no rightarg.
CREATE OPERATOR repro.@@@ (PROCEDURE = int4pl);
-- CREATE OPERATOR: unrecognized option.
CREATE OPERATOR repro.@@@ (LEFTARG = int, RIGHTARG = int, PROCEDURE = int4pl, NOSUCHOPT = x);
-- CREATE OPERATOR: commutator/negator referencing a bad operator.
CREATE OPERATOR repro.@@@ (LEFTARG = int, RIGHTARG = int, PROCEDURE = int4pl, NEGATOR = OPERATOR(pg_catalog.=));
-- Duplicate operator definition.
CREATE OPERATOR repro.@@@ (LEFTARG = int, RIGHTARG = int, PROCEDURE = int4pl);
CREATE OPERATOR repro.@@@ (LEFTARG = int, RIGHTARG = int, PROCEDURE = int4pl);
-- CREATE OPERATOR: non-boolean operator with restriction / join selectivity.
CREATE OPERATOR repro.#% (LEFTARG = int, RIGHTARG = int, PROCEDURE = int4pl, RESTRICT = eqsel);
CREATE OPERATOR repro.#& (LEFTARG = int, RIGHTARG = int, PROCEDURE = int4pl, JOIN = eqjoinsel);
-- CREATE OPERATOR: non-boolean operator marked HASHES / MERGES.
CREATE OPERATOR repro.#^ (LEFTARG = int, RIGHTARG = int, PROCEDURE = int4pl, HASHES);
CREATE OPERATOR repro.#| (LEFTARG = int, RIGHTARG = int, PROCEDURE = int4pl, MERGES);
-- CREATE OPERATOR: prefix (single-argument) operator with a commutator / HASHES /
-- join selectivity / merge join (only binary operators may have these).
CREATE OPERATOR repro.#@ (RIGHTARG = int, PROCEDURE = int4um, COMMUTATOR = OPERATOR(pg_catalog.+));
CREATE OPERATOR repro.@# (RIGHTARG = int, PROCEDURE = int4um, HASHES);
CREATE OPERATOR repro.#? (RIGHTARG = int, PROCEDURE = int4um, JOIN = eqjoinsel);
CREATE OPERATOR repro.?# (RIGHTARG = int, PROCEDURE = int4um, MERGES);
-- CREATE OPERATOR: operator with a left argument but no right argument.
CREATE OPERATOR repro.@< (LEFTARG = int, PROCEDURE = int4um);
-- CREATE OPERATOR: operator declared as its own negator.
CREATE OPERATOR repro.=?= (LEFTARG = int, RIGHTARG = int, PROCEDURE = int4eq, NEGATOR = OPERATOR(repro.=?=));

-- CREATE TYPE with I/O function references (a shell type must exist first, so
-- the full CREATE TYPE reaches the I/O-function validation branches).
CREATE TYPE repro.ts_noin;
CREATE TYPE repro.ts_noin (OUTPUT = textout);
CREATE TYPE repro.ts_noout;
CREATE TYPE repro.ts_noout (INPUT = textin);
CREATE TYPE repro.ts_tmod;
CREATE TYPE repro.ts_tmod (INPUT = textin, OUTPUT = textout, TYPMOD_OUT = int4out);
CREATE TYPE repro.ts_badin;
CREATE TYPE repro.ts_badin (INPUT = nosuchin, OUTPUT = nosuchout);
CREATE TYPE repro.ts_inret;
CREATE TYPE repro.ts_inret (INPUT = textin, OUTPUT = textout);
-- CREATE TYPE ... AS RANGE with subtype / function references.
CREATE TYPE repro.rng_nosub AS RANGE (COLLATION = "C");
CREATE TYPE repro.rng_badopt AS RANGE (SUBTYPE = int, NOSUCHOPT = 1);
CREATE TYPE repro.rng_pssub AS RANGE (SUBTYPE = anyelement);
CREATE TYPE repro.rng_nodefopc AS RANGE (SUBTYPE = xml);
CREATE TYPE repro.rng_canon AS RANGE (SUBTYPE = int, CANONICAL = nosuchcanon);
CREATE TYPE repro.rng_diff AS RANGE (SUBTYPE = int, SUBTYPE_DIFF = nosuchdiff);
CREATE TYPE repro.rng_diff2 AS RANGE (SUBTYPE = int, SUBTYPE_DIFF = int4pl);
CREATE TYPE repro.rng_opc AS RANGE (SUBTYPE = int, SUBTYPE_OPCLASS = text_ops);

-- DROP of things that do not exist.
DROP FUNCTION repro.nosuchfn();
DROP FUNCTION nosuchfn(int, int);
DROP AGGREGATE repro.nosuchagg(int);
DROP OPERATOR repro.@@@ (text, text);
-- Routines used by the kind-mismatch, ambiguity and CALL checks below.
CREATE FUNCTION repro.fn1(int) RETURNS int LANGUAGE sql AS 'SELECT $1';
CREATE PROCEDURE repro.proc_ok(a int) LANGUAGE sql AS $$ SELECT a $$;
CREATE PROCEDURE repro.proc_amb(int) LANGUAGE sql AS 'SELECT 1';
CREATE PROCEDURE repro.proc_amb(bigint) LANGUAGE sql AS 'SELECT 1';
CREATE AGGREGATE repro.agg_amb(int) (SFUNC = int4pl, STYPE = int);
-- DROP / ALTER with an object-kind mismatch (name resolves, kind is wrong).
DROP FUNCTION repro.proc_ok(int);
DROP PROCEDURE repro.srf();
DROP AGGREGATE repro.fn1(int);
ALTER FUNCTION repro.agg_amb(int) STRICT;
-- DROP with a routine kind that does not resolve by name.
DROP PROCEDURE nosuchproc;
DROP PROCEDURE nosuchproc(int);
DROP AGGREGATE nosuchagg;
DROP AGGREGATE nosuchagg(*);
DROP FUNCTION nosuchfn;
-- DROP by a bare name that is ambiguous across overloads.
DROP FUNCTION repro.ambi;
DROP ROUTINE repro.ambi;
DROP PROCEDURE repro.proc_amb;

-- CALL a non-procedure.
CALL abs(1);
-- Call a real procedure with the wrong number of arguments.
CALL repro.proc_ok();
CALL repro.proc_ok(1, 2);
-- SELECT of a procedure (procedures cannot be used as a function).
SELECT repro.proc_ok(1);
-- Ambiguous procedure resolution on CALL (two overloads via implicit cast).
CALL repro.proc_amb('7'::smallint);

-- Qualified-name resolution errors on a function reference.
SELECT nodb.repro.addone(1);
SELECT a.b.c.d.addone(1);
