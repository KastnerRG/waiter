#!/bin/bash
set -e
/home/waiter-admin/.nvm/versions/node/v22.9.0/bin/node /home/waiter-admin/.nvm/versions/node/v22.9.0/lib/node_modules/@bitwarden/cli/build/bw.js get password 'waiter-admin'
