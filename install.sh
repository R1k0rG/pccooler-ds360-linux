```bash
#!/bin/bash
set -e

echo "🚀 Installing PCCooler DS360 Driver..."

# 1. Check that the driver script exists
if [ ! -f "ds360_driver.py" ]; then
    echo "❌ Cannot find 'ds360_driver.py' in the current folder."
    echo "👉 Run this script from the cloned repository!"
    exit 1
fi

# 2. Check that pacman is available
if ! command -v pacman >/dev/null 2>&1; then
    echo "❌ This installer requires Arch Linux or a pacman-based system."
    exit 1
fi

# 3. Install required Python dependencies
echo "📦 Installing required Python packages..."
sudo pacman -S --needed python python-hidapi python-psutil

# 4. Copy the driver to system binaries
echo "📦 Copying ds360_driver.py to /usr/local/bin/..."
sudo install -m 755 ds360_driver.py /usr/local/bin/ds360_driver.py

# 5. Create the systemd service
echo "⚙️ Setting up the systemd background service..."
cat << 'EOF' | sudo tee /etc/systemd/system/pccooler-display.service > /dev/null
[Unit]
Description=PCCooler DS360 Display Control Daemon
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 -u /usr/local/bin/ds360_driver.py
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# 6. Reload systemd and start the service
echo "🔄 Reloading systemd and starting the service..."
sudo systemctl daemon-reload
sudo systemctl enable --now pccooler-display.service

echo ""
echo "🎉 Installation complete!"
echo "🔍 Check the service status with:"
echo "   sudo systemctl status pccooler-display.service"
echo ""
echo "📋 View the service logs with:"
echo "   sudo journalctl -u pccooler-display.service -b --no-pager -n 50"
```
