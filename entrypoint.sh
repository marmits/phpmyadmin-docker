#!/bin/bash
set -e

: "${SSH_USER:?missing}"
: "${SSH_HOST:?missing}"
: "${SSH_PORT:=22}"
: "${LOCAL_PORT:=3306}"
: "${REMOTE_HOST:=127.0.0.1}"
: "${REMOTE_PORT:=3306}"

echo "🔐 Starting SSH tunnel to $SSH_HOST:$REMOTE_PORT"

exec autossh \
  -M 0 \
  -N \
  -o "ServerAliveInterval=30" \
  -o "ServerAliveCountMax=3" \
  -o "ExitOnForwardFailure=yes" \
  -o "StrictHostKeyChecking=no" \
  -i /root/.ssh/id_ed25519 \
  -L 0.0.0.0:${LOCAL_PORT}:${REMOTE_HOST}:${REMOTE_PORT} \
  -p ${SSH_PORT} \
  ${SSH_USER}@${SSH_HOST}

