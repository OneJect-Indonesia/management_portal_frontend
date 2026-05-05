# Task: Code Review & Project Restructuring

**Assignee:** Junior Developer
**Reviewer:** Senior Mobile Developer

## 1. Overview

Project ini membutuhkan _refactoring_ untuk meningkatkan _maintainability_, _scalability_, dan keterbacaan kode. Saat ini, struktur folder masih mencampur beberapa _concern_ (seperti service API di dalam folder `core`), dan implementasi Dependency Injection (DI) belum diterapkan secara konsisten.

**Catatan Penting:**

- Selalu gunakan `fvm` untuk setiap command Flutter/Dart (misal: `fvm flutter pub get`, `fvm flutter test`).

---

## 2. Code Review & Saran Perbaikan (Points of Improvement)

Berdasarkan _review_ kode saat ini, berikut adalah temuan dan saran perbaikan yang harus Anda implementasikan:

### A. Penempatan File yang Kurang Tepat

- **Masalah:** File service seperti `auth_service.dart` dan `dashboard_service.dart` saat ini berada di dalam folder `lib/core/`. Folder `core` seharusnya hanya berisi hal-hal yang bersifat lintas fitur (_cross-cutting concerns_) seperti _constants_, _themes_, atau _utilities_.
- **Saran:** Pindahkan file-file service tersebut ke folder yang tepat (misalnya `lib/data/services/` atau ke dalam struktur berbasis fitur).

### B. Dependency Injection (DI) Belum Konsisten

- **Masalah:** Pada `main.dart` dan beberapa Provider, _dependencies_ (seperti Service dan Repository) diinisialisasi secara langsung di dalam kelas (contoh: `final AuthService _authService = AuthService();`). Hal ini menyulitkan saat melakukan _Unit Testing_.
- **Saran:** Terapkan Dependency Injection. Inisialisasi Service dan Repository di `main.dart` (atau gunakan _service locator_ seperti `get_it`), lalu lewatkan (_inject_) ke dalam konstruktor Provider.

### C. Error Handling

- **Masalah:** Menangkap error hanya dengan blok `catch` biasa dan mencetaknya (meskipun sudah menggunakan logger).
- **Saran:** Buat kelas _wrapper_ untuk _response_ seperti `Result<T>` atau gunakan _package_ seperti `dartz` (tipe `Either<Failure, Data>`) agar _error handling_ dari Service ke Provider lebih terstruktur.

### D. Testing

- **Masalah:** Belum ada _coverage_ test yang memadai untuk komponen UI.
- **Saran:** Tambahkan _Widget Test_ untuk halaman utama seperti `LoginPage` dan `DashboardPage`. (Unit test dasar sudah mulai disiapkan di `test/unit/`, jalankan menggunakan `fvm flutter test`).

---

## 3. Tugas: Perbaiki Struktur Folder (Folder Restructuring)

Kita akan beralih dari struktur folder saat ini ke **Feature-First Architecture** (atau Clean Architecture sederhana) agar kode lebih modular.

**Struktur Saat Ini:**

```text
lib/
├── core/       (Terdapat auth_service.dart, dashboard_service.dart)
├── interface/  (Terdapat dashboard_page.dart, login_page.dart, dll)
├── models/
├── providers/
├── repositories/
└── main.dart
```

**Tugas Anda:** Ubah struktur folder menjadi seperti di bawah ini. Pindahkan file ke tempat yang sesuai dan perbaiki semua _imports_ yang _error_. hapus jika tidak berguna

**Target Struktur Folder Baru:**

```text
lib/
├── core/                   # HANYA untuk kebutuhan lintas fitur
│   ├── constants/          # constants.dart, api_endpoints.dart
│   ├── theme/              # app_theme.dart, app_colors.dart
│   └── utils/              # logger.dart
├── data/                   # Global data sources (jika diperlukan)
│   └── local/              # session_service.dart
├── features/               # Modul berbasis fitur
│   ├── auth/               # Fitur Login/Auth
│   │   ├── models/         # user_model.dart
│   │   ├── providers/      # auth_provider.dart
│   │   ├── repositories/   # auth_repository.dart
│   │   ├── services/       # auth_service.dart
│   │   └── ui/             # login_page.dart & komponen UI auth lainnya
│   └── dashboard/          # Fitur Dashboard
│       ├── models/         # dashboard_model.dart
│       ├── providers/      # dashboard_provider.dart
│       ├── repositories/   # dashboard_repository.dart
│       ├── services/       # dashboard_service.dart
│       └── ui/             # dashboard_page.dart, widgets/, platform specific UI
└── main.dart               # Entry point & Setup DI
```

### Langkah Kerja (Checklist untuk Junior Dev):

- [ ] Buat kerangka folder baru (`lib/features/auth/...`, `lib/features/dashboard/...`, dll).
- [ ] Pindahkan `auth_service.dart` dari `core/` ke `features/auth/services/`.
- [ ] Pindahkan `dashboard_service.dart` dari `core/` ke `features/dashboard/services/`.
- [ ] Pindahkan model, provider, dan repository ke folder _feature_ masing-masing.
- [ ] Pindahkan halaman (pages) dari `interface/` ke folder `ui/` pada _feature_ yang bersesuaian.
- [ ] Perbaiki semua _error import_ di seluruh file.
- [ ] Implementasikan Dependency Injection pada `main.dart` seperti yang disarankan di Poin 2B.
- [ ] Jalankan `fvm flutter clean` dan `fvm flutter pub get`.
- [ ] Pastikan aplikasi dapat di-_build_ dan berjalan dengan normal tanpa error.
- [ ] Jalankan unit test dengan perintah `fvm flutter test` untuk memastikan _logic_ tidak rusak akibat perpindahan folder.

---
