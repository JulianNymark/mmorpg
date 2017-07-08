import main
global conn

async def players():
    players = '{"id":123, "pos":[1, 2]}'
    return players

async def player_add(name, pos):
    success = await conn.fetch('''SELECT (true);''')
    return success

async def player_move():
    # move the given player id, to a neighboring cell
    pass

async def world(rect):
    world = '[[1,2,3,4],[1,2,3,4],[1,2,3,4],[1,2,3,4]]'
    return world
