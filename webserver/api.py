async def getPlayers(conn):
    players = '{"id":123, "pos":[1, 2]}'
    return players

async def addPlayer(conn, name='anonymous', pos=[0,0]):
    global conn
    success = await conn.fetch('''SELECT (true);''')
    print(success)

async def getWorld(conn, rect):
    world = '[[1,2,3,4],[1,2,3,4],[1,2,3,4],[1,2,3,4]]'
    return world
