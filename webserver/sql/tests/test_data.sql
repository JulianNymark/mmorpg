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

RAISE INFO 'generating 1M accounts';

INSERT INTO accounts (email)
WITH random_emails as (
    SELECT alphanum_string || '@email.com' FROM random_alphanums(10, 1000000)
)
SELECT * FROM random_emails;

RAISE INFO 'generating 10M sessions (random pick from existing accounts)';

INSERT INTO sessions (email) -- WIP
WITH random_emails as (
    SELECT alphanum_string || '@email.com' FROM random_alphanums(10, 1000000)
)
SELECT * FROM random_emails;


INSERT INTO account_sessions (account, is_valid, ip_address, country_code)
VALUES ();
