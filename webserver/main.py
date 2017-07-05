#!/usr/bin/python3.6
import logging
import asyncio

from sanic import Sanic
from sanic import response
from jinja2 import Environment, FileSystemLoader, select_autoescape

import myaioredis as rj
import api

app = Sanic()

@app.route('/register', methods=['POST'])
async def handler(request):
    logging.info('POST')
    requestname = 'meme_man'
    await api.addPlayer(name=requestname, pos=[1,2])
    return response.json({"success":"success"})

@app.route('/players', methods=['POST'])
async def handler(request):
    logging.info('POST')
    json_out = await api.getPlayers()
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
    await rj.setup()

if __name__ == '__main__':
    # Load the template environment with async support
    template_env = Environment(
        loader=FileSystemLoader('./templates'),
        autoescape=select_autoescape(['html', 'xml']),
        enable_async=True
    )

    app.run(host='localhost', port=3000)
