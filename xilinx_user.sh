#!/bin/bash
set -e
env BW_SESSION=`cat .bw_session` $HOME/.nvm/versions/node/v22.9.0/bin/node $HOME/.nvm/versions/node/v22.9.0/lib/node_modules/@bitwarden/cli/build/bw.js get username 'Xilinx'
