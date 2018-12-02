#!/bin/bash
#
# SSH into the production environment.
#

set -e

BASE="$(pwd)"

ENVFILELOCATION="$BASE/.env"
if [ -f "$ENVFILELOCATION" ]; then
  source "$ENVFILELOCATION"
  if [ -z "$PROD_IP" ]; then
    >&2 echo  "PROD_IP is not set in $ENVFILELOCATION"
    exit 1
  fi
else
  >&2 echo  "$ENVFILELOCATION does not exist"
  exit 2
fi
if [ -z "$PROD_IP" ]; then
  >&2 echo "Please enter the following line in $ENVFILELOCATION"
  >&2 echo ""
  >&2 echo "PROD_USER=not_root"
  >&2 echo "PROD_IP=1.2.3.4"
  >&2 echo ""
  >&2 echo "Where not_root is your username on the remote server."
  >&2 echo "Where 1.2.3.4 is the IP of your prod environment."
  source "$ENVFILELOCATION"
fi

echo "$PROD_USER@$PROD_IP"
ssh "$PROD_USER@$PROD_IP"
