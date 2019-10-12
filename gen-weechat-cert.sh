domain=${0:-brtknr.kgz.sh}
email=${1:-brtknr@bath.edu}
sudo certbot certonly --standalone -d $domain -m $email
echo "*/set weechat.network.gnutls_ca_file '/etc/ssl/certs/ca-certificates.crt'" > ~/.weechat/weechat_fifo
echo "*/reconnect" > ~/.weechat/weechat_fifio
