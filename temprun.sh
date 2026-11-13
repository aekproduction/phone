#!/data/data/com.termux/files/usr/bin/bash

ADB_PORT=6001

echo "[*] กำลังตรวจสอบความพร้อมของระบบ..."

# 1. ตรวจสอบและติดตั้ง curl (ถ้ายังไม่มี)
if ! command -v curl &> /dev/null; then
    echo "[*] กำลังติดตั้ง curl..."
    pkg update -y && pkg install curl -y
fi

# 2. ตรวจสอบและติดตั้ง cloudflared
if ! command -v cloudflared &> /dev/null; then
    echo "[*] ไม่พบ cloudflared กำลังทำการติดตั้ง..."
    # ติดตั้ง cloudflared สำหรับ Termux
    pkg install wget -y
    # ดาวน์โหลด cloudflared มาไว้ในเครื่อง
    ARCH=$(uname -m)
    if [ "$ARCH" = "aarch64" ]; then
        curl -L --output $PREFIX/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64
    elif [ "$ARCH" = "arm" ]; then
        curl -L --output $PREFIX/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm
    elif [ "$ARCH" = "x86_64" ]; then
        curl -L --output $PREFIX/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
    fi
    chmod +x $PREFIX/bin/cloudflared
    echo "[*] ติดตั้ง cloudflared สำเร็จ!"
fi

# 3. เริ่มกระบวนการเปิดพอร์ต ADB (ต้องใช้สิทธิ์ Root / Magisk / KernelSU)
if command -v su &> /dev/null; then
    echo "[*] กำลังเปิดพอร์ต ADB ที่พอร์ต $ADB_PORT..."
    su -c "setprop service.adb.tcp.port $ADB_PORT; stop adbd; start adbd" 2>/dev/null
else
    echo "[!] คำเตือน: ไม่พบสิทธิ์ Root (su) อาจไม่สามารถเปิด ADB พอร์ตภายในเครื่องได้"
fi

echo "=========================================================="
echo "[*] กำลังสร้าง Quick Tunnel ชั่วคราว..."
echo "[!] โปรดสังเกต URL ชั่วคราว (xxxx.trycloudflare.com) ด้านล่าง"
echo "=========================================================="

cloudflared tunnel --url tcp://127.0.0.1:$ADB_PORT
