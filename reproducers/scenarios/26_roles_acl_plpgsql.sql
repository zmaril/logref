-- Roles/GRANT/REVOKE/ALTER ROLE, ALTER SYSTEM, plpgsql DO/RAISE, CALL, casts.
CREATE ROLE lowpriv;               -- already exists
CREATE ROLE r1 LOGIN PASSWORD 'x' NOSUPERUSER SUPERUSER;
ALTER ROLE nosuchrole SET work_mem = '1MB';
ALTER ROLE lowpriv SET nonexistent.guc = 'x';
ALTER ROLE lowpriv SET work_mem = 'notasize';
DROP ROLE nosuchrole;
DROP ROLE lowpriv;                 -- may own objects / be referenced
GRANT SELECT ON repro.nope TO lowpriv;
GRANT NOSUCHPRIV ON repro.parent TO lowpriv;
GRANT SELECT ON repro.parent TO nosuchrole;
GRANT lowpriv TO nosuchrole;
GRANT SELECT (nosuchcol) ON repro.parent TO lowpriv;
REVOKE SELECT ON repro.nope FROM lowpriv;
GRANT ALL ON SCHEMA nosuchschema TO lowpriv;
GRANT EXECUTE ON FUNCTION repro.nope() TO lowpriv;
ALTER TABLE repro.parent OWNER TO nosuchrole;
ALTER SCHEMA repro OWNER TO nosuchrole;
REASSIGN OWNED BY nosuchrole TO lowpriv;
DROP OWNED BY nosuchrole;
GRANT lowpriv TO lowpriv;           -- membership loop
ALTER SYSTEM SET nonexistent.guc = 'x';
ALTER SYSTEM SET work_mem = 'notasize';
ALTER SYSTEM SET shared_buffers = '1';   -- ok-to-parse but requires restart notice
ALTER SYSTEM RESET nonexistent.guc;
ALTER DATABASE nosuchdb SET work_mem = '1MB';
COMMENT ON TABLE repro.nope IS 'x';
COMMENT ON COLUMN repro.parent.nosuchcol IS 'x';
SECURITY LABEL ON TABLE repro.parent IS 'x';
CALL nosuchproc();
CREATE PROCEDURE repro.pr() LANGUAGE sql AS 'SELECT 1'; CALL repro.pr(1);
CALL repro.addone(1);               -- calling a function as procedure
SELECT repro.pr();                  -- calling a procedure as function
DO $$ BEGIN RAISE EXCEPTION 'boom %', 1 USING errcode = 'ZZ999'; END $$;
DO $$ BEGIN RAISE division_by_zero; END $$;
DO $$ BEGIN PERFORM 1/0; END $$;
DO $$ DECLARE x int; BEGIN x := 'notanint'; END $$;
DO $$ BEGIN RAISE EXCEPTION USING errcode = 'nonsense_code'; END $$;
DO $$ BEGIN ASSERT false, 'assertion text'; END $$;
DO $$ BEGIN SELECT 1 INTO STRICT x; END $$;
DO $$ BEGIN RETURN 1; END $$;
DO LANGUAGE nosuchlang $$ x $$;
DO $$ BEGIN GET DIAGNOSTICS x = ROW_COUNT; END $$;
DO $$ BEGIN RAISE NOTICE '%'; END $$;
DO $$ <<lbl>> BEGIN CONTINUE nosuchlabel; END $$;
CREATE FUNCTION repro.badret() RETURNS int LANGUAGE sql AS $$ SELECT 'x' $$;
CREATE FUNCTION repro.polymatch(anyelement) RETURNS anyarray LANGUAGE sql AS $$ SELECT 1 $$;
SELECT repro.polymatch(1);
SELECT cast(ROW(1,2) AS int);
SELECT 1::int::repro.mood;
SELECT '1'::json::int;
