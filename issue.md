# Issue: Perbaikan _Flicker_ (Jeda Render) Login Page saat Aplikasi Dimuat

Hi Team,

Terdapat masalah _User Experience_ (UX) pada mekanisme _routing_ dan autentikasi kita saat ini. Ketika _user_ yang sudah memiliki sesi valid dan berhasil membuka page dashboard dan diarahkan ke `/dashboard`, saat page direfresh maka aplikasi sempat me-render `LoginPage` selama sepersekian detik sebelum akhirnya pindah ke `DashboardPage`.

Silakan ambil _issue_ ini dan perbaiki alur inisialisasi autentikasinya.

**⚠️ Penting:** Pastikan selalu menggunakan `fvm` untuk menjalankan semua command (misalnya: `fvm flutter run -d chrome`).

---

## 🔍 Analisis Masalah

**Kenapa hal ini terjadi?**
Di dalam `AuthProvider`, pengecekan sesi (`checkSession()`) berjalan secara _asynchronous_ (asinkron).
Saat aplikasi pertama kali dijalankan, `GoRouter` akan langsung membaca status `isAuthenticated`. Karena proses `checkSession()` belum selesai membaca data dari penyimpanan lokal, `_currentUser` masih bernilai `null` (dianggap belum login).
Akibatnya, router langsung mengarahkan pengguna ke `/login`. Beberapa milidetik kemudian, `checkSession()` selesai mengeksekusi, nilai `_currentUser` terisi, dan `notifyListeners()` dipanggil. Hal ini memberitahu `GoRouter` untuk mengevaluasi ulang _redirect_, dan barulah ia mengarahkan pengguna ke `/dashboard`. Proses inilah yang menyebabkan _flicker_ atau jeda kemunculan halaman login.

---

## 📝 Tasks to Implement

Untuk memperbaiki masalah ini, kita harus memberi tahu router untuk "menunggu" sampai proses inisialisasi selesai sebelum memutuskan harus mengarahkan pengguna ke mana.

Silakan selesaikan _action items_ berikut:

### 1. Tambahkan State Inisialisasi di `AuthProvider`

Kita perlu sebuah bendera (_flag_) untuk menandakan apakah proses pengecekan sesi awal sudah selesai atau belum.

**Action Items:**

- [ ] Buka file `lib/features/auth/providers/auth_provider.dart`.
- [ ] Tambahkan variabel private `bool _isInitialized = false;` beserta _getter_-nya (`bool get isInitialized => _isInitialized;`).
- [ ] Di dalam fungsi `checkSession()`, setelah proses pengecekan selesai (setelah baris `await _sessionService.getSession()`), ubah `_isInitialized = true;`.
- [ ] Pastikan memanggil `notifyListeners()` di akhir fungsi tersebut.

### 2. Buat Halaman Splash Screen / Loading

Halaman ini akan ditampilkan selama aplikasi sedang mengecek sesi autentikasi.

**Action Items:**

- [ ] Buat file baru `lib/features/auth/ui/splash_page.dart`.
- [ ] Buat sebuah _StatelessWidget_ sederhana bernama `SplashPage`. Isinya cukup sebuah `Scaffold` dengan `Center` dan `CircularProgressIndicator` (atau bisa ditambahkan logo aplikasi agar lebih manis).

### 3. Update Logika Redirect di `GoRouter`

Sekarang kita harus memperbarui otak dari navigasinya agar mempertimbangkan _state_ `isInitialized`.

**Action Items:**

- [ ] Buka file `lib/core/routing/app_router.dart`.
- [ ] Ubah `initialLocation` dari `GoRouter` menjadi `/splash`.
- [ ] Tambahkan `GoRoute` baru di dalam daftar `routes` untuk `path: '/splash'` yang mengarahkan ke `SplashPage` yang baru saja dibuat.
- [ ] Update fungsi `redirect` di dalam konfigurasi `GoRouter` dengan urutan logika sebagai berikut:
  1. Jika `!authProvider.isInitialized`, maka kembalikan `'/splash'`. (Tahan pengguna di halaman loading).
  2. Jika proses inisialisasi sudah selesai (`isInitialized == true`) **dan** lokasi saat ini masih di `'/splash'`, arahkan pengguna berdasarkan status autentikasinya: jika `isAuthenticated` kembalikan `'/dashboard'`, jika tidak kembalikan `'/login'`.
  3. Pertahankan logika perlindungan rute (_route guard_) yang sudah ada: Jika `!isAuthenticated` dan mencoba mengakses halaman selain login, kembalikan `'/login'`. Jika `isAuthenticated` dan mencoba mengakses halaman login, kembalikan `'/dashboard'`.

---

Setelah menyelesaikan langkah-langkah di atas, lakukan testing dengan me-restart aplikasi (bukan sekadar _hot reload_). Pastikan ketika kamu sudah memiliki sesi (sudah pernah login), aplikasi akan menampilkan layar loading sejenak lalu **langsung** masuk ke dashboard tanpa memunculkan form login sama sekali.

Happy coding! 🚀
