#!/usr/bin/python3.6
import asyncio
import asyncpg
import os

from sanic import Sanic
from sanic import response
from jinja2 import Environment, FileSystemLoader, select_autoescape

app = Sanic()
conn = None

@app.route("/", methods=['POST', 'GET'])
async def hello(request):
    global conn

    json_in = '{"cool":"meme"}' # TODO: from request
    json_out = await conn.fetchrow(
        'SELECT * FROM api.move($1)', json_in)

    template = template_env.get_template('root.html')
    rendered_template = await template.render_async(json_out)
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

    # asyncio.get_event_loop().run_until_complete(main())
    print('before run()')
    app.run(host="localhost", port=3000)

    loop = app.loop
    loop.call_soon(asyncpg_setup())
    print('end of "init"')
