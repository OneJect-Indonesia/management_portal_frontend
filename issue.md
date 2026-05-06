# Application Portal - Architectural Improvements & Refactoring

Hi Team,

Berdasarkan hasil code review dan analisis arsitektur terbaru (referensi: `describe.md`), kita memiliki struktur *Feature-Based Clean Architecture* yang sudah cukup baik, namun masih ada beberapa *technical debt* dan *anti-pattern* yang perlu segera diselesaikan sebelum aplikasi di-scale lebih lanjut.

Task ini ditujukan untuk merapikan codebase, mematuhi prinsip *Separation of Concerns* (SoC), dan memastikan aplikasi siap untuk di-maintain dalam jangka panjang.

**⚠️ Penting:** Pastikan selalu menggunakan `fvm` untuk semua command (misalnya: `fvm flutter pub add <package>`).

---

## 📝 Tasks to Implement

Silakan selesaikan poin-poin berikut secara bertahap:

### 1. Refactor `SessionService` Menjadi Injectable (Bukan Static)
Saat ini `SessionService` (di `lib/data/local/session_service.dart`) menggunakan *static methods*. Hal ini menyulitkan *dependency injection* dan *mocking* untuk unit testing.

**Action Items:**
- [ ] Ubah `SessionService` menjadi *instance class* biasa (hapus keyword `static` pada method dan properties).
- [ ] Buat interface `ISessionService` yang mendefinisikan kontraknya (`saveSession`, `getSession`, `clearSession`).
- [ ] Implementasikan `ISessionService` pada `SessionService`.
- [ ] Daftarkan `SessionService` di list Provider (sebaiknya di *Dependency Injection setup* yang baru, lihat Task #4).
- [ ] Update semua pemanggilan `SessionService` di `AuthProvider` agar menggunakan dependency injection melalui konstruktor atau `context.read()`.

### 2. Pisahkan Akses API dari `SystemItemCard` UI
Terdapat pelanggaran arsitektur pada `lib/features/dashboard/ui/widgets/system_item_card.dart` di mana widget ini langsung memanggil `DashboardService.fetchSsoTicket()` alih-alih melalui layer Provider.

**Action Items:**
- [ ] Pindahkan logika pemanggilan `fetchSsoTicket` ke dalam `DashboardProvider`. Provider harus memiliki fungsi `Future<Result<String>> getSsoTicket(String token)` yang akan memanggil Repository.
- [ ] Update widget `SystemItemCard` agar memanggil fungsi `getSsoTicket` dari `DashboardProvider` (menggunakan `context.read<DashboardProvider>()`), dan menangani loading/error state berdasarkan respons dari Provider.

### 3. Implementasi Responsive Split pada Dashboard
Halaman login sudah mengimplementasikan pemisahan responsif yang baik antara mobile dan web. Hal yang sama harus diaplikasikan ke Dashboard.

**Action Items:**
- [ ] Buat dua file baru: `lib/features/dashboard/ui/mobile/dashboard_page_mobile.dart` dan `lib/features/dashboard/ui/web/dashboard_page_web.dart`.
- [ ] Pindahkan UI khusus web/desktop dari `dashboard_page.dart` ke `dashboard_page_web.dart`.
- [ ] Pindahkan UI list bottom sheet/mobile view dari `dashboard_page.dart` ke `dashboard_page_mobile.dart`.
- [ ] Ubah `lib/features/dashboard/ui/dashboard_page.dart` menjadi semata-mata sebuah *wrapper* menggunakan `LayoutBuilder` (breakpoint ~900px) yang me-return *mobile* atau *web* page, sama seperti pola pada `login_page.dart`.

### 4. Dekomposisi Tanggung Jawab di `main.dart`
File `main.dart` saat ini terlalu gemuk. Mengurus inisiasi *app*, *provider injection*, setup *theme*, sekaligus *AuthWrapper* dan *routing*.

**Action Items:**
- [ ] Pindahkan setup `MultiProvider` list ke file terpisah, misalnya di `lib/core/di/providers.dart`.
- [ ] Buat file `lib/app.dart` yang berisi widget `MyApp` (mengembalikan `MaterialApp` dengan *theme* dan *router*).
- [ ] Buat agar file `lib/main.dart` sebersih mungkin, idealnya hanya berisi fungsi `void main() => runApp(const MyApp());` atau inisialisasi dasar lainnya.

### 5. Setup Environment Configuration
URL API saat ini di-*hardcode*. Kita butuh konfigurasi *environment* yang dinamis.

**Action Items:**
- [ ] Buat file `lib/core/config/env_config.dart`.
- [ ] Implementasikan *class* konstan atau *enum* yang bisa mengembalikan `apiBaseUrl` berdasarkan current environment (misal: `dev`, `staging`, `production`).
- [ ] Update `AppConstants.apiBaseUrl` atau semua Service terkait agar memanggil *base URL* dari konfigurasi *environment* ini alih-alih string *hardcoded*.

### 6. Implementasi Routing Berbasis `go_router`
Navigasi manual berbasis *state* di `AuthWrapper` menyulitkan penambahan rute baru dan *deep linking*.

**Action Items:**
- [ ] Tambahkan package `go_router` menggunakan perintah: `fvm flutter pub add go_router`.
- [ ] Buat file `lib/core/routing/app_router.dart`.
- [ ] Konfigurasikan `GoRouter` dengan rute `/` (mengarahkan ke `LoginPage`) dan `/dashboard` (mengarahkan ke `DashboardPage`).
- [ ] Pindahkan *logic* dari `AuthWrapper` ke `redirect` handler di `go_router` (apabila user ter-autentikasi dan berada di `/`, arahkan ke `/dashboard`, dan sebaliknya).
- [ ] Hapus `AuthWrapper` jika sudah tergantikan sepenuhnya oleh mekanisme *redirect* dari router.
- [ ] Ganti `MaterialApp` dengan `MaterialApp.router` di `app.dart`.

---

Terima kasih atas bantuan dan dedikasinya. Pastikan untuk menjalankan `fvm flutter analyze` dan `fvm flutter test` sebelum membuat Pull Request untuk memastikan tidak ada *breaking changes*. 

Jika ada yang kurang jelas mengenai arsitektur atau *business requirements*, feel free untuk bertanya di kolom komentar.

Happy coding! 🚀
