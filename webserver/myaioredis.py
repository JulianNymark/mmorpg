import aioredis
import json

print('init myaioredis')

conn = None

async def setup():
    global conn

    conn = await aioredis.create_connection(
        ('localhost', 6379), encoding='utf-8')

async def GET(*arg):
    global conn

    returnval = await conn.execute('JSON.GET', *arg)
    return json.loads(returnval)

async def SET(*arg):
    global conn

    await conn.execute('JSON.SET', *arg)

async def ARRAPPEND(*arg):
    global conn

    arglist = list(arg)
    arglist[2] = json.dumps(arglist[2])
    await conn.execute('JSON.ARRAPPEND', *arglist)

async def NUMINCRBY(*arg):
    global conn

    returnval = await conn.execute('JSON.NUMINCRBY', *arg)
    return json.loads(returnval)
