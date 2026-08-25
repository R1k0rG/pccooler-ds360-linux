#!/bin/bash
set -e

echo "🗑️ Uninstalling PCCooler DS360 Driver... Cleaning up!"

# 1. Stop and disable the service if it exists
if systemctl is-active --quiet pccooler-display.service 2>/dev/null || systemctl is-enabled --quiet pccooler-display.service 2>/dev/null; then
    echo "🛑 Stopping and disabling the systemd service..."
    sudo systemctl stop pccooler-display.service || true
    sudo systemctl disable pccooler-display.service || true
fi

# 2. Remove the service file
if [ -f "/etc/systemd/system/pccooler-display.service" ]; then
    echo "🧹 Removing /etc/systemd/system/pccooler-display.service..."
    sudo rm /etc/systemd/system/pccooler-display.service
    sudo systemctl daemon-reload
fi

# 3. Remove the driver binary
if [ -f "/usr/local/bin/ds360_driver.py" ]; then
    echo "🧹 Removing /usr/local/bin/ds360_driver.py..."
    sudo rm /usr/local/bin/ds360_driver.py
fi

echo ""
echo "✨ All clear! The driver has been fully removed from your system."
