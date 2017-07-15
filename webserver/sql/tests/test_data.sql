-- UTILITY FUNCTIONS

CREATE OR REPLACE FUNCTION random_alphanum(len_str integer)
RETURNS table (
    alphanum_string text
)
AS $$
    BEGIN
        RETURN QUERY
        SELECT
            string_agg(
                substr(characters, (random() * length(characters) + 1)::integer, 1), ''
            ) AS alphanum_string
        FROM (
            VALUES('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789')
        ) AS symbols(characters)
        JOIN generate_series(1, len_str) ON true;
    END;
$$ LANGUAGE plpgsql STABLE;

CREATE OR REPLACE FUNCTION random_alphanums(len_str integer, num_str integer)
RETURNS table (
    alphanum_string text
)
AS $$
    BEGIN
        RETURN QUERY
        SELECT random_alphanum(len_str) FROM generate_series(1, num_str);
    END;
$$ LANGUAGE plpgsql STABLE;

---------------------

DO $$
    BEGIN
        RAISE INFO 'generating 1000 accounts';
    END;
$$;

INSERT INTO accounts (email)
WITH random_emails as (
    SELECT alphanum_string || '@email.com' FROM random_alphanums(10, 1000)
)
SELECT * FROM random_emails;

-- TODO plpgsql for loop
DO $$
    BEGIN
        RAISE INFO 'generating 1 session per account!';
    END;
$$;

INSERT INTO account_sessions (account, ip_address)
WITH sa AS (
    SELECT * FROM accounts
)
SELECT sa.account, '123.123.123.123'::inet FROM sa;

DO $$
    BEGIN
        RAISE INFO 'generating 1 session per account!';
    END;
$$;
INSERT INTO account_sessions (account, ip_address)
WITH sa AS (
    SELECT * FROM accounts
)
SELECT sa.account, '123.123.123.123'::inet FROM sa;

-- MAP data
DO $$
BEGIN
   RAISE INFO 'MAP DATA';
   -- loop for x and y
    FOR i IN 1..25 LOOP
        -- memes
    END LOOP;
END;
$$;

---------------- some 'specific' data

INSERT INTO players (username, x, y) VALUES ('player1', 42, 42);
INSERT INTO players (username, x, y) VALUES ('player2', 43, 43);
