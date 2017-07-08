#!/usr/bin/python3.6
import asyncio
import asyncpg
import os

from sanic import Sanic
from sanic import response
from jinja2 import Environment, FileSystemLoader, select_autoescape

import api

app = Sanic()
conn = None

@app.route('/register', methods=['POST'])
async def handler(request):
    requestname = 'meme_man'
    await api.player_add(name=requestname, pos=[1,2])
    return response.json({"success":"success"})

@app.route('/players', methods=['POST'])
async def handler(request):
    json_out = await api.players()
    return response.json(json_out)

@app.route('/world', methods=['POST'])
async def handler(request):
    # TODO limit size of request
    # TODO limit size of rect (logic here or -> api or -> redis?)
    print('#####################')
    json_in = request.json
    json_out = await api.world(json_in['rect'])
    return response.json(json_out)

@app.route('/', methods=['GET'])
async def handler(request):
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

@app.listener('before_server_start')
async def connect_to_db(app, loop):
    global conn
    password = os.environ['MMORPG_PG_PASSWORD']
    conn = await asyncpg.connect(user='mmorpg', password=f'{password}',
                                 database='mmorpg', host='127.0.0.1')

if __name__ == '__main__':
    # Load the template environment with async support
    template_env = Environment(
        loader=FileSystemLoader('./templates'),
        autoescape=select_autoescape(['html', 'xml']),
        enable_async=True
    )

    app.run(host='localhost', port=3000, debug=True)
