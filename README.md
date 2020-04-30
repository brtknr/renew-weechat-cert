# Setup

	git clone https://github.com/brtknr/renew-weechat-cert.git
        cd renew-weechat-cert

# First use

        ./gen-weechat-cert.sh brtknr.kgz.sh brtknr@bath.edu
        ./install-weechat-service.sh

NOTE: this also makes a crontab entry which renews every 2 months.

# Manual renewal

        ./renew-weechat-cert.sh brtknr.kgz.sh
