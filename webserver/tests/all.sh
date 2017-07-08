#!/bin/bash
set -euo pipefail

curl -s -X POST  localhost:3000/register | jq .
curl -s -X POST  localhost:3000/players | jq .
curl -s -X POST  localhost:3000/world -d '{"rect":[[0,0], [4,20]]}' | jq .

# TODO
# curl -s -X POST  localhost:3000/move | jq .

# cool demo query of 2d slicing! (also showcasing how cool jq is)
# INSERT INTO smiley VALUES (
# ARRAY[
# [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
# [' ', ' ', ' ', 'X', ' ', 'X', ' ', ' ', ' ', ' '],
# [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
# [' ', ' ', 'X', ' ', ' ', ' ', 'X', ' ', ' ', ' '],
# [' ', ' ', 'X', ' ', ' ', ' ', 'X', ' ', ' ', ' '],
# [' ', ' ', ' ','X', ' ', ' ', 'X', ' ', ' ', ' ' ],
# [' ', ' ', ' ', ' ', 'X', 'X', ' ', ' ', ' ', ' '],
# [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
# [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
# [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
# ]
# );
# psql -h localhost -U mmorpg -d mmorpg -t -c 'SELECT array_to_json(pixel[2:7][3:7]) FROM smiley;' | jq -c '.[]'
