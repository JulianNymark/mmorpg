#!/usr/bin/python3.6
import asyncio
import os
import logging

from sanic import Sanic
from sanic import response
from jinja2 import Environment, FileSystemLoader, select_autoescape

app = Sanic()

@app.route("/", methods=['POST'])
async def hello(request):
    logging.info('POST', request)
    json_in = "meme"
    json_out = """{"players":[
    {"id":"1001", "pos":"42.0, 43.0"},
    {"id":"1002", "pos":"4.0, 432.0"}
    ]}"""

    return response.json(
        {
            "players": [{"id":"1001", "pos":"42.0, 43.0"},
                        {"id":"1002", "pos":"4.0, 432.0"}
            ]
        }
    )

@app.route("/", methods=['GET'])
async def hello(request):
    logging.info('GET', request)
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
    app.run(host="localhost", port=3000)

async def asyncpg_setup():
    password = str(os.environ['MMORPG_PG_PASSWORD'])
    conn = await asyncpg.connect('postgresql://mmorpg@localhost/mmorpg', password=password)
    print('end of asyncpg_setup()')
    # await conn.close()

if __name__ == "__main__":
    # Load the template environment with async support
    template_env = Environment(
        loader=FileSystemLoader('./templates'),
        autoescape=select_autoescape(['html', 'xml']),
        enable_async=True
    )

    app.run(host="localhost", port=3000)
