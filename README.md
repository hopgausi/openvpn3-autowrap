# openvpn3-autowrap

Automated OpenVPN 3 wrapper for Linux with Sophos 2FA support and self-healing configuration management.

## ✨ Features

- **Automatic Profile Management**: Detects and purges duplicate configuration paths before importing fresh profiles.
- **2FA Integration**: Uses `expect` to automate the handshake between your credentials and the Sophos/OpenVPN MFA prompt.
- **Session Self-Healing**: Automatically identifies and closes "stuck" sessions (tun interfaces) before attempting a new connection.
- **Detailed Verbosity**: Built-in status and stop commands for easy CLI management.

## 🛠 Prerequisites

Ensure you have the following installed:

- `openvpn3-linux`
- `expect`
- `grep`, `awk`, `xargs` (standard on most distros)

## 🚀 Installation

1. **Clone the repo:**
   ```bash
   git clone https://github.com/hopgausi/openvpn3-autowrap.git
   cd openvpn3-autowrap
   chmod +x vpn.sh
   mkdir -p ~/bin
   cp vpn.sh ~/bin/vpn
   ```
2. **Configure your credentials and ovpn filepath:** Edit the top of the vpn script with your VPN username, password and path to your .ovpn file.

   ```
   nano ~/bin/vpn
   ```

3. **Usage**

| Command      | Action                                                         |
| ------------ | -------------------------------------------------------------- |
| `vpn start`  | Cleans duplicates, imports config, and starts session with 2FA |
| `vpn stop`   | Safely disconnects all active sessions                         |
| `vpn status` | Shows current session info and connection paths                |

## 🖥️ System Tray Monitoring (Optional)

To see your VPN status in the GNOME top bar at all times:

1. **Install the monitor:**
   ```bash
   sudo apt update && sudo apt install indicator-sysmonitor
   ```
2. **Launch it** and go to `Preferences` -> `Advanced`.

3. **Create a new sensor** called "VPN":

   - **Command:** `IP=$(openvpn3 sessions-list | grep "Connected to:" | awk -F: '{print $3}' | head -n 1); if [ -z "$IP" ]; then echo "off"; else echo "on($IP)"; fi`

4. **Add** `vpn: {VPN}` to your customization line in the Sensors tab.
5. **You should be able to see the vpn status in the top bar of the system monitor**
