#!/data/data/com.termux/files/usr/bin/bash

ADB_PORT=6001

if command -v su &> /dev/null; then
    echo "[*] กำลังเปิดพอร์ต ADB..."
    su -c "setprop service.adb.tcp.port $ADB_PORT; stop adbd; start adbd" 2>/dev/null
fi

echo "=========================================================="
echo "[*] กำลังสร้าง Quick Tunnel ชั่วคราว..."
echo "[!] โปรดสังเกต URL ชั่วคราว (xxxx.trycloudflare.com) ด้านล่าง"
echo "=========================================================="


cloudflared tunnel --url tcp://127.0.0.1:$ADB_PORT

# cloudflared access tcp --hostname brave-cat-1234.trycloudflare.com --url 127.0.0.1:6001
# adb connect 127.0.0.1:6001
