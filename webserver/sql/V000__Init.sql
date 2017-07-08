CREATE TABLE accounts (
    account BIGSERIAL PRIMARY KEY,
    email citext UNIQUE NOT NULL,
);

CREATE TABLE sessions (
    session BIGSERIAL PRIMARY KEY,
    ctime DEFAULT now() NOT NULL,

    REFERENCES account USING (account)
);

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
    mtime DEFAULT now() NOT NULL, -- 'for clientside caching terrain'
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
