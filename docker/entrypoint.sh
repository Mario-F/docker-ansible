#!/bin/bash

set -e

PYTHON_REQ=$(mktemp)
ANSIBLE_REQ=${ANSIBLE_REQ:-requirements.yml}
SSH_DIR=/ssh

# if path is directory, copy all files
if [ -d "$SSH_DIR" ]; then
  mkdir -p /root/.ssh
  rsync -r $SSH_DIR/ /root/.ssh/
fi

if [ "$1" = 'default' ]; then
  if test -f "$PYTHON_REQ"; then
      echo "Install $PYTHON_REQ"
      pipenv requirements > "$PYTHON_REQ"
      pip install --break-system-packages -r "$PYTHON_REQ"
  fi

  if test -f "$ANSIBLE_REQ"; then
      echo "Install $ANSIBLE_REQ"
      ansible-galaxy install -r $ANSIBLE_REQ
  fi
  exec "zsh"
else
  exec "$@"
fi
