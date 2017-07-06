import aioredis
import json

print('init myaioredis')

conn = None

async def setup():
    global conn
    conn = await aioredis.create_connection(
        ('localhost', 6379), encoding='utf-8')

    # initial players
    await SET('players:id', '.', '0', 'NX')
    await SET('players', '.', '[]', 'NX')

    # initial world
    world = [
        [1, 1, 1, 1],
        [1, 0, 1, 1],
        [1, 0, 0, 0],
        [1, 1, 1, 1],
    ]
    await SET('world', '.', json.dumps(world), 'NX')

async def GET(*arg):
    returnval = await conn.execute('JSON.GET', *arg)
    return json.loads(returnval)

async def SET(*arg):
    await conn.execute('JSON.SET', *arg)

async def ARRAPPEND(*arg):
    arglist = list(arg)
    arglist[2] = json.dumps(arglist[2])
    await conn.execute('JSON.ARRAPPEND', *arglist)

async def NUMINCRBY(*arg):
    returnval = await conn.execute('JSON.NUMINCRBY', *arg)
    return returnval

async def EVAL(*arg):
    returnval = await conn.execute('EVAL', *arg)
    print('#######################')
    print(returnval)
    return returnval
