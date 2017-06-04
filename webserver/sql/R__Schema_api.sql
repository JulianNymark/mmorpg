---- stay fresh  ----

DROP SCHEMA IF EXISTS api CASCADE;
CREATE SCHEMA api;

DROP USER IF EXISTS "mmorpg-api";
CREATE USER "mmorpg-api";

---- functions ----

CREATE OR REPLACE FUNCTION api.move (
    p_input jsonb
) RETURNS jsonb AS $$
    BEGIN
        RETURN '{"cool":"beans"}';
    END;
$$ LANGUAGE plpgsql;

---- grants ----

GRANT EXECUTE ON FUNCTION api.move(jsonb) TO "mmorpg-api";
