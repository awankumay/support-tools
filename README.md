# Support Tools

## Cara Pemakaian `tools.sh`

`tools.sh` adalah skrip shell yang dikembangkan untuk membantu dalam berbagai tugas pendukung. Berikut adalah langkah-langkah untuk menggunakan `tools.sh`:

### Prasyarat
Pastikan Anda memiliki:
- Bash shell terinstal di sistem Anda.
- Izin eksekusi untuk `tools.sh`.

### Langkah-langkah Penggunaan

1. **Navigasi ke Direktori Skrip**
    ```sh
    cd /home/acw/Deploy/support-tools/
    ```

2. **Memberikan Izin Eksekusi**
    Jika skrip belum memiliki izin eksekusi, berikan izin dengan perintah berikut:
    ```sh
    chmod +x tools.sh
    ```

3. **Menjalankan Skrip**
    Jalankan skrip dengan perintah berikut:
    ```sh
    ./tools.sh
    ```

4. **Menggunakan Opsi Skrip**
    `tools.sh` memiliki beberapa opsi atau argumen yang dapat digunakan. Untuk melihat daftar opsi yang tersedia, jalankan:
    ```sh
    ./tools.sh --help
    ```

### Contoh Penggunaan
Berikut adalah beberapa contoh penggunaan `tools.sh`:

- Mengirim email percobaan menggunakan sendmail:
  ```sh
  ./tools.sh --sendmail --email example@example.com
  ```

- Mengirim laporan logwatch:
  ```sh
  ./tools.sh --logwatch --email example@example.com
  ```

- Menjalankan skrip langsung dari URL menggunakan `curl`:
  ```sh
  curl -s https://raw.githubusercontent.com/awankumay/support-tools/main/tools.sh | bash -s -- --sendmail --email example@example.com
  ```

### Troubleshooting
Jika Anda mengalami masalah saat menjalankan `tools.sh`, pastikan:
- Anda berada di direktori yang benar.
- Skrip memiliki izin eksekusi.
- Anda menggunakan versi Bash yang kompatibel.

Untuk informasi lebih lanjut, silakan lihat dokumentasi atau hubungi tim pengembang.
