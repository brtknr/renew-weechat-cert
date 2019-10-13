#!/usr/bin/env bash
set -x

sudo cat /etc/letsencrypt/live/${DOMAIN}/{fullchain,privkey}.pem > ~/.weechat/ssl/relay.pem
echo "*/relay sslcertkey" > ~/.weechat/weechat_fifo
(crontab -l; echo "0 3 1 */2 * $(pwd)/renew-weechat-cert.sh ${DOMAIN}") | crontab
echo "*/reconnect" > ~/.weechat/weechat_fifio
