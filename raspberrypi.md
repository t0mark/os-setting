```bash
sudo apt update -y
sudo apt upgrade -y

# ko typing setting
sudo apt install fonts-nanum -y
sudo apt install ibus ibus-hangul -y

# chromium ko setting
echo 'export CHROMIUM_FLAGS="$CHROMIUM_FLAGS --ozone-platform=x11"' | sudo tee /etc/chromium.d/99-ozone-x11
```
