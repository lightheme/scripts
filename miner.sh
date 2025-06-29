sudo apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev

cd ~/Downloads

git clone https://github.com/xmrig/xmrig.git

cd xmrig

mkdir build

cd build

sudo cmake ..

sudo make -j$(nproc --all)

sudo mkdir /opt/xmrig

sudo cp ./xmrig /opt/xmrig/xmrig

sudo cat <<EOL | sudo tee /opt/xmrig/config.json
{
  "autosave": false,
  "background": false,
  "colors": true,
  "cpu": {
    "huge-pages": true,
    "1gb-pages": true,
    "priority": 5,
    "threads": 80,
    "affinity": -1,
    "max-cpu-usage": 100,
    "asm": "auto",
    "memory-pool": true,
    "argon2-impl": "avx2",
    "astrobwt-max-size": 524288
  },
  "pools": [
    {
      "url": "xmr-ru.kryptex.network:7029",
      "user": "41hPRPwkazMZKHg9xdt6fL8Pm4nu2eNDqagwkFnayRMRUNocrE67vWWBRVsBLBLvitiFvk5GgpBZSM97FDTn6zD4MeqYva3/yandex",
      "pass": "D4MeqYva3",
      "keepalive": true,
      "algo": "rx/0",
      "retries": 5,
      "retry-pause": 5
    }
  ],
  "donate-level": 0,
  "log-file": "xmrig.log",
  "api": {
    "port": 0,
    "access-token": null,
    "restricted": true
  }
}
EOL

sudo cat <<EOL | sudo tee /etc/systemd/system/xmrig.service
[Unit]
Description=XMRig Daemon
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=sudo /opt/xmrig/xmrig --config=/opt/xmrig/config.json
Restart=always

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload
sudo systemctl enable xmrig.service
sudo systemctl start xmrig.service
