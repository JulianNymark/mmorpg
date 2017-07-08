CREATE TABLE accounts (
    account BIGSERIAL PRIMARY KEY,
    email citext UNIQUE NOT NULL,
);

CREATE TABLE players (
    player BIGSERIAL PRIMARY KEY,
    username varchar(20) UNIQUE NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL ,
    pos point NOT NULL
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
