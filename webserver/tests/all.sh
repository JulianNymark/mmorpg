#!/bin/bash
set -euo pipefail

curl -s -X POST  localhost:3000/register | jq .
curl -s -X POST  localhost:3000/players | jq .
curl -s -X POST  localhost:3000/world -d '{"rect":[[0,0], [4,20]]}' | jq .

# TODO
# curl -s -X POST  localhost:3000/move | jq .
