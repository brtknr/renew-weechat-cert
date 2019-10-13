#! /usr/bin/env bash
set -x

export DOMAIN=${0:-brtknr.kgz.sh}
sudo certbot renew
bash link.sh
