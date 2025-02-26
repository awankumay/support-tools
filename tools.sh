#!/bin/bash

# Default email
EMAIL=""

# Cek apakah script dijalankan sebagai root
if [[ $EUID -ne 0 ]]; then
    SUDO="sudo"
else
    SUDO=""
fi


# Function to check sendmail status
check_sendmail_status() {
    if systemctl is-active --quiet sendmail; then
        echo "✅ Sendmail service is running."
    else
        echo "❌ Sendmail service is NOT running."
        echo "⚠️  Coba jalankan: ${SUDO} systemctl start sendmail"
        exit 1
    fi
}

# Function to reconfigure sendmail
reconfig_sendmail() {
    echo "🔧 Memulai konfigurasi ulang sendmail..."
    
    # Hentikan service sendmail sebelum konfigurasi ulang
    ${SUDO} systemctl stop sendmail

    # Hapus konfigurasi yang lama jika perlu
    ${SUDO} rm -rf /etc/mail/sendmail.cf /etc/mail/submit.cf

    # Jalankan ulang konfigurasi
    ${SUDO} sendmailconfig
    
    # Reload dan restart sendmail
    ${SUDO} systemctl daemon-reload
    ${SUDO} systemctl start sendmail
    ${SUDO} systemctl enable sendmail

    # Periksa apakah berhasil dijalankan
    if systemctl is-active --quiet sendmail; then
        echo "✅ Konfigurasi ulang sendmail berhasil!"
    else
        echo "❌ Gagal mengkonfigurasi ulang sendmail."
        exit 1
    fi
}

# Function to test sendmail (Tanpa Pengecekan Otomatis)
test_sendmail() {
    if [[ -z "$EMAIL" ]]; then
        echo "❌ Error: Email tidak diberikan!"
        exit 1
    fi

    SUBJECT="Test Email from Ubuntu Server"
    BODY="Halo, ini adalah email percobaan dari $(hostname) menggunakan sendmail."

    echo -e "Subject: $SUBJECT\n\n$BODY" | sendmail -v "$EMAIL"

    if [[ $? -eq 0 ]]; then
        echo "✅ Email berhasil dikirim ke $EMAIL"
    else
        echo "❌ Gagal mengirim email ke $EMAIL"
    fi
}

# Function to send logwatch report (Tanpa Pengecekan Otomatis)
send_logwatch() {
    if [[ -z "$EMAIL" ]]; then
        echo "❌ Error: Email tidak diberikan!"
        exit 1
    fi

    # Bersihkan logwatch temp jika ada error sebelumnya
    ${SUDO} rm -rf /tmp/logwatch.*

    # Jalankan logwatch
    ${SUDO} logwatch --output mail --mailto "$EMAIL" --detail high

    if [[ $? -eq 0 ]]; then
        echo "✅ Laporan logwatch berhasil dikirim ke $EMAIL"
    else
        echo "❌ Gagal mengirim laporan logwatch ke $EMAIL"
    fi
}

# Parsing arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --sendmail | --sm) MODE="sendmail" ;;
        --logwatch | --lw) MODE="logwatch" ;;
        --sendmail-status | --ss) MODE="sendmail-status" ;;
        --reconfig-sendmail | --rs) MODE="reconfig-sendmail" ;;
        --email) EMAIL="$2"; shift ;;
        *) echo "❌ Argumen tidak dikenal: $1"; exit 1 ;;
    esac
    shift
done

# Menjalankan sesuai dengan mode yang dipilih
if [[ "$MODE" == "sendmail" ]]; then
    test_sendmail
elif [[ "$MODE" == "logwatch" ]]; then
    send_logwatch
elif [[ "$MODE" == "sendmail-status" ]]; then
    check_sendmail_status
elif [[ "$MODE" == "reconfig-sendmail" ]]; then
    reconfig_sendmail
else
    echo "⚠️  Gunakan salah satu opsi berikut:"
    echo "   --sendmail --email <email>       # Kirim test email"
    echo "   --logwatch --email <email>       # Kirim laporan logwatch"
    echo "   --sendmail-status                # Cek status sendmail"
    echo "   --reconfig-sendmail              # Konfigurasi ulang sendmail"
    exit 1
fi
