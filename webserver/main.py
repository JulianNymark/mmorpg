#!/usr/bin/python3.6
import os
import logging
import asyncio
import aioredis
import json

from sanic import Sanic
from sanic import response
from jinja2 import Environment, FileSystemLoader, select_autoescape

conn = None
app = Sanic()
#password = str(os.environ['MMORPG_REDIS_PASSWORD'])

@app.route('/register', methods=['POST'])
async def handler(request):
    logging.info('POST')
    requestname = 'meme_man'
    await addPlayer(name=requestname, pos=[1,2])
    return response.json({"success":"success"})

@app.route('/players', methods=['POST'])
async def handler(request):
    logging.info('POST')
    json_out = await getPlayers()
    return response.json(json_out)

@app.route('/', methods=['GET'])
async def handler(request):
    logging.info('GET')
    template = template_env.get_template('root.html')
    rendered_template = await template.render_async()

    return response.html(
        rendered_template,
        headers={
            'X-Served-By': 'sanic',
            'X-good': 'shit',
            'X-poop': ':poop:',
            'X-server-quality': 'incredible',
            'Response-time': '0',
            'Server-process-time': '0'},
        status=200
    )

async def main():
    app.run(host='localhost', port=3000)

@app.listener('before_server_start')
async def setup_db(app, loop):
    global conn
    conn = await aioredis.create_connection(
        ('localhost', 6379), encoding='utf-8')

async def getPlayers():
    players = await conn.execute('JSON.GET', 'players')
    return json.loads(players)

async def addPlayer(name='anonymous', pos=[0,0]):
    await conn.execute('JSON.SET', 'players:id', '.', '0', 'NX')
    await conn.execute('JSON.SET', 'players', '.', '[]', 'NX')

    player_id = await conn.execute('JSON.NUMINCRBY', 'players:id', '1')

    obj = {
        "id" : player_id,
        "name" : name,
        "pos" : pos
    }
    players = await conn.execute('JSON.ARRAPPEND', 'players', '.', json.dumps(obj))

if __name__ == '__main__':
    # Load the template environment with async support
    template_env = Environment(
        loader=FileSystemLoader('./templates'),
        autoescape=select_autoescape(['html', 'xml']),
        enable_async=True
    )

    app.run(host='localhost', port=3000)
