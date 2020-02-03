#! /usr/bin/env bash
set -x

export DOMAIN=${1:-brtknr.kgz.sh}
export EMAIL=${2:-brtknr@bath.edu}

sudo certbot certonly --standalone -d ${DOMAIN} -m ${EMAIL} 
echo "*/set weechat.network.gnutls_ca_file '/etc/ssl/certs/ca-certificates.crt'" > ~/.weechat/weechat_fifo
bash link.sh
