#!/usr/bin/env bash
set -e
/home/waiter-admin/.nvm/nvm.sh exec 22.9.0
/home/waiter-admin/.nvm/versions/node/v22.9.0/bin/bw get password 'waiter-admin'
