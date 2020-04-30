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
