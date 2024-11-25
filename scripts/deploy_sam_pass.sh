#!/bin/bash
NODE=$HOME/.nvm/versions/node/v22.9.0/bin/node
BW=$HOME/.nvm/versions/node/v22.9.0/lib/node_modules/@bitwarden/cli/build/bw.js
BW_SESSION=`cat .bw_session`
LABEL_STUDIO_API_KEY=`$NODE $BW --session $BW_SESSION get password "waiter label_studio API Key"`
echo "LABEL_STUDIO_API_KEY=\"$LABEL_STUDIO_API_KEY\"" > $HOME/waiter/.secrets/segment_anything.env
