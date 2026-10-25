#!/bin/bash
set -e

echo "🚀 Installing PCCooler DS360 Driver... Let's get this display working!"

# 1. Make sure the main script is actually here
if [ ! -f "ds360_driver.py" ]; then
    echo "❌ Woops! Cannot find 'ds360_driver.py' in the current folder."
    echo "👉 Make sure you're running this script inside the cloned repository!"
    exit 1
fi

# 2. Copy the driver to system binaries
echo "📦 Copying ds360_driver.py to /usr/local/bin/..."
sudo cp ds360_driver.py /usr/local/bin/ds360_driver.py
sudo chmod +x /usr/local/bin/ds360_driver.py

# 3. Create systemd daemon service
echo "⚙️ Setting up the systemd background service..."
cat << 'EOF' | sudo tee /etc/systemd/system/pccooler-display.service > /dev/null
[Unit]
Description=PCCooler DS360 Display Control Daemon
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /usr/local/bin/ds360_driver.py
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# 4. Reload systemd and enable service on boot
echo "🔄 Reloading systemd units and firing up the service..."
sudo systemctl daemon-reload
sudo systemctl enable --now pccooler-display.service

echo ""
echo "🎉 Boom! Installed & running like a charm!"
echo "🔍 Want to check if it's alive? Run:"
echo "   sudo systemctl status pccooler-display.service"

где добавить sudo pacman -S --needed python python-hidapi python-psutil
