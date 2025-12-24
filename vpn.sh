#!/bin/bash

# Configuration

USER="vpn_username" # e.g. "john.doe"
PASS="vpn_password" # e.g. "SuperSecretPassword"
CONFIG= # e.g. "development_vpn"
OVPN_FILE="/path/to/{vpn_profile}.ovpn" # e.g. "/home/user/vpn/development_vpn.ovpn"

case "$1" in
    start)
        # 1. DELETE ALL existing configs using the verbose path list
        PATHS=$(openvpn3 configs-list --verbose | grep -B 3 -w "$CONFIG" | grep "/net/openvpn/v3/configuration")
        
        if [ -n "$PATHS" ]; then
            echo "🧹 Removing old profiles..."
            echo "$PATHS" | xargs -L1 openvpn3 config-remove --force --path >/dev/null 2>&1
            sleep 1
        fi
        
        # 2. Import a single fresh profile
        if [ -f "$OVPN_FILE" ]; then
            echo "📥 Importing fresh profile: $CONFIG"
            openvpn3 config-import --config "$OVPN_FILE" --name "$CONFIG" --persistent >/dev/null
        else
            echo "❌ Error: $OVPN_FILE not found."
            exit 1
        fi
        
        # 3. Prevent duplicate sessions (Clear old tunnels)
        STUCK=$(openvpn3 sessions-list | grep "Path:" | awk '{print $2}')
        if [ -n "$STUCK" ]; then
            echo "🔌 Closing old sessions..."
            echo "$STUCK" | xargs -L1 openvpn3 session-manage --disconnect --path >/dev/null 2>&1
        fi
        
        # 4. Ask for the 2FA code
        echo -n "Enter Sophos Authenticator Code: "
        read CODE
        echo ""
        
        # 5. Start the session
        /usr/bin/expect <<EOF
            set timeout 30
            spawn openvpn3 session-start --config $CONFIG
            expect "Auth User name:"
            send "$USER\r"
            expect "Auth Password:"
            send "$PASS$CODE\r"
            expect {
                "Connected" { exit 0 }
                eof { exit 0 }
            }

EOF
    ;;
    
    stop)
        echo "Stopping OpenVPN 3 sessions..."
        openvpn3 sessions-list | grep "Path:" | awk '{print $2}' | while read -r path; do
            openvpn3 session-manage --path "$path" --disconnect
        done
        echo "✅ VPN Stopped."
    ;;
    
    status)
        openvpn3 sessions-list
    ;;
    
    *)
        echo "Usage: vpn {start|stop|status}"
        exit 1
    ;;
    
esac
