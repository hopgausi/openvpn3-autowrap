# openvpn3-autowrap

Automated OpenVPN 3 wrapper for Linux with Sophos 2FA support and self-healing configuration management. Start | Stop | Status VPN session with 2FA made easy.

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
