#!/bin/bash
set -o errexit

apt-get remove chromium --purge
rm -rf ~/.config/chromium || true
rm -rf ~/.cache/chromium || true
rm -rf /etc/chromium || true
rm /headless/Desktop/chromium-browser.desktop