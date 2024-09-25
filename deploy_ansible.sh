#!/bin/bash
cd /home/waiter-admin/waiter
set -e

# Change to main branch if needed
BRANCH="$(git branch --show-current)"
if [ "$BRANCH" != "main" ]
then
  git checkout main -q
fi

# Deploy if changes have been made
GIT_STATUS="$(git status -s)"
if [ -n "$GIT_STATUS" ]
then
    source .venv/bin/activate
    ansible-galaxy collection install -r requirements.yml
    ansible-playbook playbook.yaml
    docker compose pull
    docker compose up --detach
    docker image prune
fi