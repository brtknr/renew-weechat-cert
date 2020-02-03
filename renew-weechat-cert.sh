#! /usr/bin/env bash
set -x

export DOMAIN=${1:-brtknr.kgz.sh}
sudo certbot renew
bash link.sh
