# Task: Pembaruan README dan Konfigurasi Gitignore

## Deskripsi
Tugas ini bertujuan untuk memperbarui dokumentasi proyek agar sesuai dengan kondisi aplikasi saat ini, serta memperbaiki konfigurasi git agar direktori lingkungan AI/Agent tidak masuk ke dalam repository.

## Catatan Penting (Wajib Diperhatikan)
- **Penggunaan FVM**: Proyek ini menggunakan Flutter Version Management (FVM). Oleh karena itu, **semua** eksekusi perintah Flutter harus diawali dengan `fvm` (contoh: `fvm flutter pub get` atau `fvm flutter run`).
- **Port Web**: Untuk menjalankan project pada platform web, wajib menggunakan port **8083** (contoh: `fvm flutter run -d web --web-port 8083`).

*(Catatan untuk Developer/Model: Cukup buat panduan ini sampai pada level yang jelas arahnya, biarkan ruang untuk eksplorasi tanpa harus terlalu detail dan kaku).*

## Daftar Pekerjaan (To-Do)

### 1. Perbarui `README.md`
Ubah isi file `README.md` agar relevan dengan kondisi project management portal frontend saat ini. Pastikan poin-poin berikut ada di dalamnya:
- **Alur Project (Flow)**: Penjelasan singkat tentang gambaran umum dan alur kerja aplikasi.
- **Kegunaan Project**: Tujuan dari aplikasi ini dibuat.
- **Cara Menjalankan (Getting Started)**: Panduan singkat cara instalasi dan menjalankan project (pastikan memasukkan poin penting terkait FVM dan Port 8083 di atas).
- **Informasi Penting Lainnya**: Info tambahan yang sekiranya krusial untuk dipahami oleh orang yang baru bergabung ke dalam project.

### 2. Perbaiki file `.gitignore`
Pastikan environment agent lokal tidak ikut ter-commit ke dalam repository git.
- Tambahkan folder `./.agent/` ke dalam file `.gitignore` agar folder tersebut diabaikan oleh Git.
