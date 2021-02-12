#! /usr/bin/env bash
set -x

export DOMAIN=${1:-chat.rawn.uk}
export EMAIL=${2:-brtknr@bath.edu}

sudo certbot renew --cert-name ${DOMAIN} || sudo certbot certonly --manual --preferred-challenges=dns -d ${DOMAIN} -m ${EMAIL}
sudo cat /etc/letsencrypt/live/${DOMAIN}/{fullchain,privkey}.pem > ~/.weechat/ssl/relay.pem

echo "*/set weechat.network.gnutls_ca_file '/etc/ssl/certs/ca-certificates.crt'" > ~/.weechat/weechat_fifo
echo "*/relay sslcertkey" > ~/.weechat/weechat_fifo
(crontab -l; echo "0 3 1 */2 * $(pwd)/$(basename $0) ${DOMAIN}") | uniq | crontab
echo "*/reconnect" > ~/.weechat/weechat_fifo

if [[ ! -f /etc/systemd/system/weechat.service ]]; then
    cat << EOF | sudo tee /etc/systemd/system/weechat.service
[Unit]
Description=A WeeChat client and relay service using Tmux
After=network.target

[Service]
User=$USER
Group=$USER
Type=forking
RemainAfterExit=yes
ExecStart=/usr/bin/tmux -L weechat new -d -s weechat weechat
ExecStop=/usr/bin/tmux -L weechat kill-session -t weechat

[Install]
WantedBy=default.target
EOF
    sudo systemctl enable weechat.service
    sudo systemctl start weechat.service
fi

