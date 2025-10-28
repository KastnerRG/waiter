#!/bin/bash
NODE=$HOME/.nvm/versions/node/v22.9.0/bin/node
BW=$HOME/.nvm/versions/node/v22.9.0/lib/node_modules/@bitwarden/cli/build/bw.js
BW_SESSION=`cat .bw_session`
OCTOPRINT_API_KEY=`$NODE $BW --session $BW_SESSION get password "Octoprint Prometheus API Key"`
echo "OCTOPRINT_API_KEY=\"$OCTOPRINT_API_KEY\"" > $HOME/waiter/.secrets/octoprint_api_key.env
