#! /usr/bin/env bash

RESULT=`sudo certbot certificates -d *.rawn.uk`

set -x

export DOMAIN=${1:-chat.rawn.uk}
export EMAIL=${2:-brtknr@bath.edu}

echo "Europe/London" | sudo tee /etc/timezone

CERTNAME=`echo "$RESULT" | grep "Certificate Name" | cut -f5 -d" "`

if [[ -n "$CERTNAME" ]]; then
    sudo certbot renew --cert-name $CERTNAME --pre-hook 'systemctl stop nginx' --post-hook 'systemctl start nginx'
else
    sudo certbot certonly --agree-tos --preferred-challenges=dns --manual -d ${DOMAIN} -m ${EMAIL}
fi
mv ~/.weechat/certs/relay.pem{,.bak}
sudo cat /etc/letsencrypt/live/${DOMAIN}/{fullchain,privkey}.pem > ~/.weechat/certs/relay.pem
echo "*/set weechat.network.gnutls_ca_file /etc/ssl/certs/ca-certificates.crt" > ~/.weechat/weechat_fifo
echo "*/set relay.network.ssl_cert_key %h/certs/relay.pem" > ~/.weechat/weechat_fifo
echo "*/relay sslcertkey" > ~/.weechat/weechat_fifo
echo "*/save" > ~/.weechat/weechat_fifo
diff ~/.weechat/certs/relay.pem{,.bak} || (echo "*/reconnect" > ~/.weechat/weechat_fifo)

(crontab -l; echo "0 3 * * * $(readlink -f $0) ${DOMAIN}") | uniq | crontab

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

