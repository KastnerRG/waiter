#!/bin/bash
flock --nonblock /var/lock/waiter_cron_cd.lock /home/waiter-admin/waiter/deploy_ansible.sh