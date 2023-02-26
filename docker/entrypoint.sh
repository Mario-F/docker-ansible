#!/bin/bash

set -e

PYTHON_REQ=$(mktemp)
ANSIBLE_REQ=requirements.yml
SSH_DIR=/ssh

# if path is directory, copy all files
if [ -d "$SSH_DIR" ]; then
  mkdir -p /root/.ssh
  rsync -r $SSH_DIR/ /root/.ssh/
fi

if [ "$1" = 'default' ]; then
  if test -f "$PYTHON_REQ"; then
      echo "Install $PYTHON_REQ"
      python3 -m pip install pipenv
      python3 -m pipenv requirements > "$PYTHON_REQ"
      python3 -m pip install -r "$PYTHON_REQ"
  fi

  if test -f "$ANSIBLE_REQ"; then
      echo "Install $ANSIBLE_REQ"
      ansible-galaxy install -r $ANSIBLE_REQ
  fi
  exec "zsh"
else
  exec "$@"
fi
