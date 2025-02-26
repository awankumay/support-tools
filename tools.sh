#!/bin/bash

# Default email
EMAIL=""

# Function to test sendmail
test_sendmail() {
    if [[ -z "$EMAIL" ]]; then
        echo "Error: Email tidak diberikan!"
        exit 1
    fi

    SUBJECT="Test Email from Ubuntu Server"
    BODY="Halo, ini adalah email percobaan dari $(hostname) menggunakan sendmail."

    echo -e "Subject: $SUBJECT\n\n$BODY" | sendmail -v "$EMAIL"

    if [[ $? -eq 0 ]]; then
        echo "Email berhasil dikirim ke $EMAIL"
    else
        echo "Gagal mengirim email ke $EMAIL"
    fi
}

# Function to send logwatch report
send_logwatch() {
    if [[ -z "$EMAIL" ]]; then
        echo "Error: Email tidak diberikan!"
        exit 1
    fi

    # Bersihkan logwatch temp jika ada error sebelumnya
    sudo rm -rf /tmp/logwatch.*

    # Jalankan logwatch
    sudo logwatch --output mail --mailto "$EMAIL" --detail high

    if [[ $? -eq 0 ]]; then
        echo "Laporan logwatch berhasil dikirim ke $EMAIL"
    else
        echo "Gagal mengirim laporan logwatch ke $EMAIL"
    fi
}

# Parsing arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --sendmail) MODE="sendmail" ;;
        --logwatch) MODE="logwatch" ;;
        --email) EMAIL="$2"; shift ;;
        *) echo "Argumen tidak dikenal: $1"; exit 1 ;;
    esac
    shift
done

# Menjalankan sesuai dengan mode yang dipilih
if [[ "$MODE" == "sendmail" ]]; then
    test_sendmail
elif [[ "$MODE" == "logwatch" ]]; then
    send_logwatch
else
    echo "Gunakan --sendmail atau --logwatch dengan --email <email_address>"
    exit 1
fi
