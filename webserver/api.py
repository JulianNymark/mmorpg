import myaioredis as rj

async def getPlayers():
    players = await rj.GET('players')
    return players

async def addPlayer(name='anonymous', pos=[0,0]):
    player_id = await rj.NUMINCRBY('players:id', '1')

    obj = {
        "id" : player_id,
        "name" : name,
        "pos" : pos
    }
    players = await rj.ARRAPPEND('players', '.', obj)

async def getWorld(rect):
    # world = await rj.GET('world', '[0][1]')
    # TODO... some EVAL script
    world = await rj.EVAL("return {{1,1},{1,0}}", 0)
    return world
