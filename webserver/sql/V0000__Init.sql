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

CREATE TABLE sessions (
    session BIGSERIAL PRIMARY KEY,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL,
    ctime timestamptz DEFAULT now() NOT NULL,
    account bigint NOT NULL,
    is_valid bool DEFAULT true NOT NULL,

    FOREIGN KEY (account) REFERENCES accounts (account)
);

-- trigger set all other sessions to 'invalid' on new session
CREATE FUNCTION sessions_invalidate_old() RETURNS trigger AS
$$ BEGIN
    UPDATE sessions SET is_valid = false
    WHERE session <> NEW.session;
    RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER sessions_invalidate_old AFTER INSERT ON sessions
FOR EACH ROW EXECUTE PROCEDURE sessions_invalidate_old();

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
-- IDEA:
-- accounts correspond to 'ghosts' that can possess a player in the world...
