-- Tier 2 (deep) — contrib text-search dictionaries and trigger-only functions:
-- option validation (dict_int, unaccent) and trigger-context guards (tcn, lo),
-- plus fuzzystrmatch length limits. All are ereport paths a stock cluster can
-- drive with no corruption.

-- dict_int: template option validation (dict_int.c).
ALTER TEXT SEARCH DICTIONARY intdict (maxlen = 0);
ALTER TEXT SEARCH DICTIONARY intdict (nosuchparam = 1);

-- unaccent: Rules/parameter validation and missing-file open (unaccent.c).
CREATE TEXT SEARCH DICTIONARY repro_un1 (template = unaccent, rules = 'a', rules = 'b');
CREATE TEXT SEARCH DICTIONARY repro_un2 (template = unaccent, bogusparam = 'x');
CREATE TEXT SEARCH DICTIONARY repro_un3 (template = unaccent);
CREATE TEXT SEARCH DICTIONARY repro_un4 (template = unaccent, rules = 'no_such_unaccent_file_xyz');

-- tcn: triggered_change_notification context guards (tcn.c). Called directly,
-- and mis-wired as BEFORE/STATEMENT/one-arg/no-PK/TRUNCATE triggers.
SELECT triggered_change_notification();
CREATE TABLE repro.tcn_pk (id int PRIMARY KEY, v text);
CREATE TABLE repro.tcn_nopk (id int, v text);
CREATE TRIGGER tcn_before BEFORE INSERT ON repro.tcn_pk
    FOR EACH ROW EXECUTE FUNCTION triggered_change_notification();
INSERT INTO repro.tcn_pk VALUES (1, 'a');
CREATE TRIGGER tcn_stmt AFTER INSERT ON repro.tcn_pk
    FOR EACH STATEMENT EXECUTE FUNCTION triggered_change_notification();
INSERT INTO repro.tcn_pk VALUES (2, 'b');
CREATE TRIGGER tcn_arg AFTER INSERT ON repro.tcn_pk
    FOR EACH ROW EXECUTE FUNCTION triggered_change_notification('extra');
INSERT INTO repro.tcn_pk VALUES (3, 'c');
CREATE TRIGGER tcn_trunc AFTER TRUNCATE ON repro.tcn_pk
    FOR EACH STATEMENT EXECUTE FUNCTION triggered_change_notification();
TRUNCATE repro.tcn_pk;
CREATE TRIGGER tcn_nopk AFTER INSERT ON repro.tcn_nopk
    FOR EACH ROW EXECUTE FUNCTION triggered_change_notification();
INSERT INTO repro.tcn_nopk VALUES (1, 'a');

-- lo: lo_manage trigger-context guards (lo.c). Direct call and mis-wired forms.
SELECT lo_manage();
CREATE TABLE repro.lot (id int, img oid);
CREATE TRIGGER lo_stmt BEFORE UPDATE ON repro.lot
    FOR EACH STATEMENT EXECUTE FUNCTION lo_manage();
UPDATE repro.lot SET img = img;
CREATE TRIGGER lo_nocol BEFORE UPDATE ON repro.lot
    FOR EACH ROW EXECUTE FUNCTION lo_manage();
UPDATE repro.lot SET img = img;
CREATE TRIGGER lo_badcol BEFORE UPDATE ON repro.lot
    FOR EACH ROW EXECUTE FUNCTION lo_manage('no_such_column');
UPDATE repro.lot SET img = img;

-- fuzzystrmatch: argument/metaphone length limits (fuzzystrmatch.c).
SELECT levenshtein(repeat('x', 300), 'y');
SELECT metaphone('', 5);
SELECT metaphone('abc', 0);
