# Issue: Perbaikan Web Routing dan Dokumentasi Struktur Folder

Hi Team,

Setelah me-review implementasi arsitektur dan routing terbaru di proyek _Application Management Portal_, ada beberapa hal yang perlu dirapikan, khususnya terkait _User Experience_ di platform Web dan kejelasan struktur folder.

Silakan ambil issue ini dan implementasikan perbaikannya.

**⚠️ Penting:** Pastikan selalu menggunakan `fvm` untuk menjalankan semua command (misalnya: `fvm flutter run -d chrome`).

---

## 📝 Tasks to Implement

Silakan selesaikan poin-poin berikut:

### 1. Dokumentasi/Standardisasi Folder `lib/core/di`

**Konteks:** Saat ini kita memiliki folder `lib/core/di`. Beberapa _developer_ mungkin bertanya-tanya, _"Kenapa namanya `di`? Apakah tidak ada penamaan lain?"_
Singkatan `di` merujuk pada **Dependency Injection**. Ini adalah konvensi umum, tetapi agar tidak membingungkan tim (terutama yang baru bergabung):
**Action Items:**

- [ ] Jika dirasa `di` terlalu ambigu, silakan _rename_ folder tersebut menjadi `lib/core/injection` atau `lib/core/providers` dan pastikan semua _import_ yang terkait diperbarui.

### 2. Perbaiki Isu Hash Routing pada Web (`#/login`)

**Konteks:** Saat ini jika aplikasi dijalankan di web dan kita berada di halaman login, URL di browser menunjukkan `http://localhost:8083/login#/login`. Hal ini terjadi karena secara _default_ Flutter Web menggunakan _hash-based routing_.
**Action Items:**

- [ ] Hilangkan hash (`#`) dari URL untuk platform web dengan menggunakan _Path URL Strategy_.
- [ ] Buka file `lib/main.dart` (atau tempat inisialisasi awal) dan panggil fungsi `usePathUrlStrategy();` sebelum `runApp()`. (Kamu perlu melakukan import `package:flutter_web_plugins/url_strategy.dart`).

### 3. Sinkronisasi Browser URL dengan Router State

**Konteks:** Saat ini, ketika _user_ sudah berhasil masuk ke dalam Dashboard, URL di browser web seringkali masih tertahan di `http://localhost:8083/login`. Hal ini membuat navigasi dan _refresh_ halaman di browser menjadi tidak konsisten.
**Action Items:**

- [ ] Periksa kembali konfigurasi `GoRouter` di `lib/core/routing/app_router.dart`.
- [ ] Pastikan mekanisme `redirect` berjalan sinkron dengan update URL di browser web. Implementasi `usePathUrlStrategy()` di poin ke-2 biasanya akan sangat membantu mengatasi masalah ini.
- [ ] Lakukan _testing_ di web browser: pastikan saat sukses login, URL bar berubah menjadi `http://localhost:8083/dashboard`, dan jika di-_refresh_ pada state _logged in_, _user_ tetap berada di dashboard dengan URL yang benar.

---
