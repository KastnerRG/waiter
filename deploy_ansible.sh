#!/bin/bash
cd /home/waiter-admin/waiter
set -ex

# Change to main branch if needed
BRANCH="$(git branch --show-current)"
if [ "$BRANCH" != "main" ]
then
  git checkout main -q
fi

# Deploy if changes have been made
git remote update
GIT_STATUS="$(git diff origin/main)"
if [ -n "$GIT_STATUS" ]
then
    git pull
    source .venv/bin/activate
    ansible-galaxy collection install -r requirements.yml
    ANSIBLE_CONFIG='/home/waiter-admin/waiter/ansible.cfg'
    ANSIBLE_INVENTORY='/home/waiter-admin/waiter/inventory.yaml'
    BW_SESSION=`cat /home/waiter-admin/bw_session`
    ansible-playbook playbook.yaml
    docker compose pull
    docker compose up --detach
    docker image prune -f
fi