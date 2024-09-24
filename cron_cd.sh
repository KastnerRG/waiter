#!/bin/bash
flock --nonblock /var/lock/waiter_cron_cd.lock /home/waiter/waiter/deploy_ansible.sh