DOMAIN_NAME=$1
sudo certbot renew
sudo cat /etc/letsencrypt/live/${DOMAIN_NAME}/{fullchain,privkey}.pem > ~/.weechat/ssl/relay.pem
echo "*/relay sslcertkey" > ~/.weechat/weechat_fifo
(crontab -l; echo "0 3 1 */2 * $(pwd)/renew-weechat-cert.sh ${DOMAIN_NAME}") | crontab
