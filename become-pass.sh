#!/bin/bash
set -e
BW_SESSION=`cat /home/waiter-admin/bw_session`
date >> ./become-pass.log
env >> ./become-pass.log
/home/waiter-admin/.nvm/versions/node/v22.9.0/bin/node /home/waiter-admin/.nvm/versions/node/v22.9.0/lib/node_modules/@bitwarden/cli/build/bw.js get password 'waiter-admin'
