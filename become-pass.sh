#!/bin/bash
set -e
source /home/waiter-admin/.bashrc
nvm exec 22.9.0
/home/waiter-admin/.nvm/versions/node/v22.9.0/bin/bw get password 'waiter-admin'
