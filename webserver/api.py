import myaioredis as rj

async def getPlayers():
    players = await rj.GET('players')
    return players

async def addPlayer(name='anonymous', pos=[0,0]):
    await rj.SET('players:id', '.', '0', 'NX')
    await rj.SET('players', '.', '[]', 'NX')

    player_id = await rj.NUMINCRBY('players:id', '1')

    obj = {
        "id" : player_id,
        "name" : name,
        "pos" : pos
    }
    players = await rj.ARRAPPEND('players', '.', obj)
