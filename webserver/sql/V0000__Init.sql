CREATE EXTENSION IF NOT EXISTS "citext";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE accounts (
    account BIGSERIAL PRIMARY KEY,
    email citext UNIQUE NOT NULL,

    CHECK (
        char_length(email) < 255
        AND email ~ '@'
    )
);

CREATE TABLE account_sessions (
    account_session BIGSERIAL PRIMARY KEY,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL,
    ctime timestamptz DEFAULT now() NOT NULL,

    account bigint NOT NULL,
    ip_address inet NOT NULL,

    country_code varchar(2),

    FOREIGN KEY (account) REFERENCES accounts (account)
);

-- CREATE INDEX valid_sessions_idx ON account_sessions (account_session)
-- WHERE is_valid IS true;
--
-- ?? ^^ exhibits strange behaviour... slow inserting on sessions
-- ...trying without partial index

CREATE TABLE valid_account_sessions (
    valid_account_session BIGSERIAL PRIMARY KEY,
    account_session bigint NOT NULL,
    account bigint NOT NULL UNIQUE,

    FOREIGN KEY (account) REFERENCES accounts (account), -- TODO: DRY? ^
    FOREIGN KEY (account_session) REFERENCES account_sessions (account_session)
);

-- trigger set all other account_sessions to 'invalid' on new account_session
CREATE FUNCTION account_sessions_new() RETURNS trigger AS
$$ BEGIN
    -- drop all other valid account sessions owned by that account
    DELETE FROM valid_account_sessions
    WHERE account = NEW.account;

    INSERT INTO valid_account_sessions
    (account_session, account)
    VALUES
    (NEW.account_session, NEW.account);
    RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER account_sessions_new AFTER INSERT ON account_sessions
FOR EACH ROW EXECUTE PROCEDURE account_sessions_new();

CREATE TABLE players (
    player BIGSERIAL PRIMARY KEY,
    username varchar(20) UNIQUE NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL ,
    x bigint NOT NULL,
    y bigint NOT NULL
);

CREATE TYPE terrain_type AS ENUM (
    'grass',
    'rock'
);

CREATE TABLE terrain_tiles (
    terrain_tile BIGSERIAL PRIMARY KEY,
    x bigint NOT NULL,
    y bigint NOT NULL,
    mtime timestamptz DEFAULT now() NOT NULL, -- 'for clientside caching terrain'
    terrain terrain_type NOT NULL, -- visual
    passable boolean DEFAULT true NOT NULL,

    UNIQUE (x, y)
);

-- CREATE TABLE inventory
-- CREATE TABLE experience / skills
-- CREATE TABLE items

-- NOTE:
-- simulate 'cycle / preservation of resource life'...
-- when 3 pieces of wood are destroyed... grow a tree that drops 3 pieces of wood when chopped... etc...
--
-- what about players inventories? they could keep resources there indefinitely... :thinking:
--
-- should let players play the game fully _without_ an account / email... then create one if they want
-- to get the advantages an account brings (persistent playerdata stored remotely? email spam?... etc)
--
-- IDEA:
-- accounts correspond to 'ghosts' that can possess a player in the world...
