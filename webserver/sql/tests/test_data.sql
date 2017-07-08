CREATE FUNCTION random_string()
RETURNS text
AS $$
    BEGIN
        SELECT
            string_agg(
                substr(characters, (random() * length(characters) + 1)::integer, 1), ''
            ) AS random_word
        FROM (
            VALUES('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789')
        ) AS symbols(characters)
        JOIN generate_series(1, 20) ON true;
    END;
$$ LANGUAGE plpgsql;

INSERT INTO accounts (email)
WITH random_emails as (

)
SELECT random_email FROM random_emails;

INSERT INTO account_sessions (account, is_valid, ip_address, country_code)
VALUES ();
