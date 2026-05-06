# 📁 Folder Structure — Application Management Portal (Frontend)

> **Framework**: Flutter (Dart)  
> **State Management**: Provider  
> **Architecture Pattern**: Feature-Based Clean Architecture  
> **Tanggal Analisis**: 6 Mei 2026

---

## 1. Struktur Folder Lengkap

```
frontend/
├── lib/
│   ├── main.dart                              # Entry point & DI setup (MultiProvider)
│   │
│   ├── core/                                  # Shared utilities & konfigurasi global
│   │   ├── constants/
│   │   │   └── constants.dart                 # API base URL, endpoints, timeout
│   │   ├── theme/
│   │   │   ├── app_colors.dart                # Palet warna aplikasi
│   │   │   └── app_theme.dart                 # ThemeData (Material 3)
│   │   └── utils/
│   │       ├── logger.dart                    # Wrapper Logger (PrettyPrinter)
│   │       └── result.dart                    # Generic Result<T> pattern
│   │
│   ├── data/                                  # Data layer global (non-feature-specific)
│   │   └── local/
│   │       └── session_service.dart           # Secure storage untuk user session
│   │
│   └── features/                              # Fitur-fitur aplikasi (modular)
│       ├── auth/                              # ── Feature: Authentication ──
│       │   ├── models/
│       │   │   └── user_model.dart            # UserModel (fromJson, toJson)
│       │   ├── providers/
│       │   │   └── auth_provider.dart         # ChangeNotifier untuk state auth
│       │   ├── repositories/
│       │   │   └── auth_repository.dart       # IAuthRepository + implementasi
│       │   ├── services/
│       │   │   └── auth_service.dart          # HTTP calls (login, device info)
│       │   └── ui/
│       │       ├── login_page.dart            # Responsive wrapper (LayoutBuilder)
│       │       ├── mobile/
│       │       │   └── login_page_mobile.dart # UI login untuk mobile
│       │       └── web/
│       │           └── login_page_web.dart    # UI login untuk web/tablet
│       │
│       └── dashboard/                         # ── Feature: Dashboard ──
│           ├── models/
│           │   └── dashboard_model.dart       # DashboardModel, DashboardData, MenuItem, Module, Content
│           ├── providers/
│           │   └── dashboard_provider.dart    # ChangeNotifier untuk state dashboard
│           ├── repositories/
│           │   └── dashboard_repository.dart  # IDashboardRepository + implementasi
│           ├── services/
│           │   └── dashboard_service.dart     # HTTP calls (dashboard data, SSO ticket)
│           └── ui/
│               ├── dashboard_page.dart        # Halaman utama dashboard
│               ├── mobile/                    # (kosong — belum diimplementasi)
│               ├── web/                       # (kosong — belum diimplementasi)
│               └── widgets/
│                   ├── category_card.dart     # Widget card untuk kategori
│                   └── system_item_card.dart  # Widget card untuk item sistem
│
├── test/                                      # Test files
│   ├── features/
│   │   ├── auth/
│   │   │   └── ui/
│   │   │       └── login_page_test.dart       # Widget test halaman login
│   │   └── dashboard/
│   │       └── ui/
│   │           └── dashboard_page_test.dart   # Widget test halaman dashboard
│   └── unit/                                  # (kosong — belum ada unit test)
│
├── pubspec.yaml                               # Dependencies & project config
├── analysis_options.yaml                      # Lint rules
└── README.md
```

---

## 2. Penjelasan Tiap Layer

### 2.1 `lib/core/` — Shared Core
Layer ini berisi kode yang **tidak terikat ke fitur manapun** dan digunakan secara global:

| Folder | Isi | Fungsi |
|---|---|---|
| `constants/` | `constants.dart` | Menyimpan API base URL, endpoint, dan timeout |
| `theme/` | `app_colors.dart`, `app_theme.dart` | Palet warna dan konfigurasi `ThemeData` Material 3 |
| `utils/` | `logger.dart`, `result.dart` | Logger wrapper dan `Result<T>` pattern untuk error handling |

### 2.2 `lib/data/` — Global Data Layer
Berisi service yang bersifat **cross-feature**, seperti `SessionService` yang mengelola penyimpanan sesi user ke `FlutterSecureStorage`.

### 2.3 `lib/features/` — Feature Modules
Setiap fitur memiliki **sub-folder yang identik**, mengikuti pola Clean Architecture:

```
feature/
├── models/         → Data class / entity
├── services/       → HTTP / external API calls
├── repositories/   → Abstraksi (interface) + implementasi
├── providers/      → State management (ChangeNotifier)
└── ui/             → Widget / halaman UI
    ├── mobile/     → Layout khusus mobile
    ├── web/        → Layout khusus web/tablet
    └── widgets/    → Reusable widget per-fitur
```

### 2.4 `test/` — Testing
Struktur test **mirror** dari `lib/features/`, yang memudahkan mapping file test ke file source.

---

## 3. Evaluasi Best Practice

### ✅ Yang Sudah Baik

| # | Aspek | Detail |
|---|---|---|
| 1 | **Feature-Based Architecture** | Setiap fitur (auth, dashboard) memiliki folder sendiri yang terpisah dengan layer yang jelas (`models`, `services`, `repositories`, `providers`, `ui`). Ini **sesuai best practice** Flutter untuk proyek skala menengah–besar. |
| 2 | **Dependency Injection** | Menggunakan `MultiProvider` + `ProxyProvider` + `ChangeNotifierProxyProvider` di `main.dart` untuk meng-inject dependency secara berantai: `Service → Repository → Provider`. Ini memungkinkan **testability yang tinggi**. |
| 3 | **Repository Pattern + Interface** | `AuthRepository` dan `DashboardRepository` menggunakan abstract class (`IAuthRepository`, `IDashboardRepository`), sehingga memudahkan mocking untuk testing. |
| 4 | **Result Pattern** | Menggunakan `Result<T>` untuk menangani success/failure tanpa exception, mengurangi try-catch boilerplate di layer atas. |
| 5 | **Responsive UI Strategy** | Login page menggunakan `LayoutBuilder` dengan breakpoint 800px untuk memisahkan tampilan mobile dan web. Dashboard juga responsif dengan breakpoint 900px. |
| 6 | **Test Structure Mirror** | Folder `test/features/` mencerminkan `lib/features/`, mempermudah navigasi. |
| 7 | **Secure Storage untuk Session** | Token disimpan menggunakan `FlutterSecureStorage`, bukan `SharedPreferences`, yang lebih aman. |
| 8 | **Material 3** | `useMaterial3: true` sudah diaktifkan di `ThemeData`. |

### ⚠️ Yang Perlu Diperbaiki / Belum Optimal

| # | Aspek | Masalah | Severity |
|---|---|---|---|
| 1 | **`SessionService` adalah static class** | Semua method di `SessionService` bersifat `static`, sehingga tidak bisa di-inject atau di-mock saat testing. `AuthProvider` langsung memanggil `SessionService.getSession()` tanpa abstraksi. | 🔴 High |
| 2 | **`SystemItemCard` langsung akses `DashboardService`** | Widget `SystemItemCard` memanggil `context.read<DashboardService>()` langsung, melewati layer Repository dan Provider. Ini melanggar prinsip separation of concern. | 🔴 High |
| 3 | **Dashboard belum punya responsive split (mobile/web)** | Folder `dashboard/ui/mobile/` dan `dashboard/ui/web/` kosong. Semua logika UI ada di `dashboard_page.dart` (290 baris), belum dipecah seperti login. | 🟡 Medium |
| 4 | **`main.dart` terlalu banyak tanggung jawab** | `main.dart` berisi `MyApp` (DI setup), `AuthWrapper` (session check + routing), dan logika navigasi. Sebaiknya dipisah. | 🟡 Medium |
| 5 | **Tidak ada `app_router.dart`** | Navigasi dilakukan langsung di `AuthWrapper` tanpa routing system (baik `GoRouter` atau `Navigator 2.0`). Sulit di-scale saat fitur bertambah. | 🟡 Medium |
| 6 | **Tidak ada barrel files (export files)** | Setiap file import path lengkap (`../../../core/utils/result.dart`). Barrel file bisa mempermudah import dan mengurangi coupling. | 🟢 Low |
| 7 | **`test/unit/` kosong** | Hanya ada widget test, belum ada unit test untuk `Service`, `Repository`, atau `Provider`. | 🟡 Medium |
| 8 | **Model class tanpa `Equatable` / `==` override** | `UserModel` dan `DashboardModel` tidak mengimplementasi `Equatable` atau override `==` dan `hashCode`. Ini menyulitkan comparison di test dan state management. | 🟢 Low |
| 9 | **Tidak ada environment config** | API base URL hardcoded (`http://127.0.0.1:80/api/v1`). Belum ada mekanisme untuk switch antara dev/staging/production. | 🟡 Medium |
| 10 | **Comment campur bahasa** | Ada comment dalam Bahasa Indonesia dan Inggris di file yang sama (misalnya di `dashboard_model.dart` dan `system_item_card.dart`). | 🟢 Low |

---

## 4. Rekomendasi Improvement

### 🔴 Prioritas Tinggi

#### 4.1 Jadikan `SessionService` Injectable (Bukan Static)

**Masalah**: `SessionService` menggunakan static methods sehingga tidak bisa di-mock atau di-inject.

**Solusi**: Ubah menjadi instance class dan inject melalui Provider.

```dart
// SEBELUM (static)
class SessionService {
  static Future<void> saveSession(UserModel user) async { ... }
}

// SESUDAH (injectable)
abstract class ISessionService {
  Future<void> saveSession(UserModel user);
  Future<UserModel?> getSession();
  Future<void> clearSession();
}

class SessionService implements ISessionService {
  final FlutterSecureStorage _storage;
  SessionService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> saveSession(UserModel user) async { ... }
}
```

Lalu inject di `main.dart`:
```dart
Provider<ISessionService>(create: (_) => SessionService()),
```

#### 4.2 Pindahkan SSO Logic dari `SystemItemCard` ke Provider

**Masalah**: Widget langsung memanggil `DashboardService.fetchSsoTicket()`, melanggar arsitektur.

**Solusi**: Tambahkan method di `DashboardProvider` atau buat `SsoProvider` khusus.

```dart
// Di DashboardProvider
Future<Result<String>> getSsoTicket(String token) {
  return _dashboardRepository.getSsoTicket(token);
}
```

```dart
// Di SystemItemCard — gunakan Provider, bukan Service langsung
final result = await context.read<DashboardProvider>().getSsoTicket(token);
```

---

### 🟡 Prioritas Sedang

#### 4.3 Pisahkan `main.dart`

Buat file terpisah:

```
lib/
├── main.dart              # Hanya void main() => runApp(MyApp())
├── app.dart               # MyApp widget + MaterialApp config
├── core/
│   └── di/
│       └── providers.dart # List<SingleChildWidget> untuk MultiProvider
│   └── routing/
│       └── app_router.dart # Routing configuration
```

#### 4.4 Tambahkan Router

Gunakan package `go_router` untuk navigasi yang lebih scalable:

```yaml
dependencies:
  go_router: ^15.0.0
```

```dart
// core/routing/app_router.dart
final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const LoginPage()),
    GoRoute(path: '/dashboard', builder: (_, __) => const DashboardPage()),
  ],
  redirect: (context, state) {
    final isAuth = context.read<AuthProvider>().isAuthenticated;
    if (!isAuth && state.uri.path != '/') return '/';
    if (isAuth && state.uri.path == '/') return '/dashboard';
    return null;
  },
);
```

#### 4.5 Pecah Dashboard UI (Mobile/Web)

Samakan pattern dengan Login Page:

```dart
// dashboard/ui/dashboard_page.dart
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return const DashboardPageWeb();
        } else {
          return const DashboardPageMobile();
        }
      },
    );
  }
}
```

#### 4.6 Tambahkan Environment Config

```dart
// core/config/env_config.dart
enum Environment { dev, staging, production }

class EnvConfig {
  static Environment current = Environment.dev;

  static String get apiBaseUrl {
    switch (current) {
      case Environment.dev:
        return 'http://127.0.0.1:80/api/v1';
      case Environment.staging:
        return 'https://staging-api.example.com/api/v1';
      case Environment.production:
        return 'https://api.example.com/api/v1';
    }
  }
}
```

#### 4.7 Lengkapi Unit Test

Tambahkan test untuk setiap layer:

```
test/
├── features/
│   ├── auth/
│   │   ├── services/
│   │   │   └── auth_service_test.dart       # Mock HTTP client
│   │   ├── repositories/
│   │   │   └── auth_repository_test.dart    # Mock service
│   │   ├── providers/
│   │   │   └── auth_provider_test.dart      # Mock repository
│   │   └── ui/
│   │       └── login_page_test.dart         # (sudah ada)
│   └── dashboard/
│       ├── services/
│       │   └── dashboard_service_test.dart
│       ├── repositories/
│       │   └── dashboard_repository_test.dart
│       ├── providers/
│       │   └── dashboard_provider_test.dart
│       └── ui/
│           └── dashboard_page_test.dart     # (sudah ada)
└── core/
    └── utils/
        └── result_test.dart
```

---

### 🟢 Prioritas Rendah

#### 4.8 Tambahkan Barrel Files

```dart
// lib/features/auth/auth.dart
export 'models/user_model.dart';
export 'providers/auth_provider.dart';
export 'repositories/auth_repository.dart';
export 'services/auth_service.dart';
export 'ui/login_page.dart';
```

Sehingga import cukup:
```dart
import 'package:frontend/features/auth/auth.dart';
```

#### 4.9 Tambahkan `Equatable` ke Model

```yaml
dependencies:
  equatable: ^2.0.7
```

```dart
class UserModel extends Equatable {
  // ...
  @override
  List<Object?> get props => [id, nik, fullName, department, role, token];
}
```

#### 4.10 Konsistensi Bahasa Comment

Pilih **satu bahasa** untuk semua comment dan documentation. Rekomendasi: **Bahasa Inggris** agar konsisten dengan nama variabel dan method.

---

## 5. Struktur Folder Ideal (Target)

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── config/
│   │   └── env_config.dart
│   ├── constants/
│   │   └── constants.dart
│   ├── di/
│   │   └── providers.dart
│   ├── routing/
│   │   └── app_router.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   └── utils/
│       ├── logger.dart
│       └── result.dart
│
├── data/
│   └── local/
│       └── session_service.dart
│
└── features/
    ├── auth/
    │   ├── auth.dart                  # Barrel file
    │   ├── models/
    │   ├── providers/
    │   ├── repositories/
    │   ├── services/
    │   └── ui/
    │       ├── login_page.dart
    │       ├── mobile/
    │       ├── web/
    │       └── widgets/
    │
    └── dashboard/
        ├── dashboard.dart             # Barrel file
        ├── models/
        ├── providers/
        ├── repositories/
        ├── services/
        └── ui/
            ├── dashboard_page.dart
            ├── mobile/
            │   └── dashboard_page_mobile.dart
            ├── web/
            │   └── dashboard_page_web.dart
            └── widgets/
```

---

## 6. Ringkasan Skor

| Aspek | Skor | Catatan |
|---|:---:|---|
| Modularitas (Feature-Based) | ⭐⭐⭐⭐⭐ | Sangat baik, sudah terpisah per-fitur |
| Separation of Concerns | ⭐⭐⭐⭐ | Bagus, tapi ada pelanggaran di `SystemItemCard` |
| Dependency Injection | ⭐⭐⭐⭐ | Baik via Provider, tapi `SessionService` masih static |
| Testability | ⭐⭐⭐ | Interface sudah ada, tapi unit test belum lengkap |
| Scalability | ⭐⭐⭐ | Butuh router & env config untuk scaling |
| Code Consistency | ⭐⭐⭐ | Bahasa comment campur, dashboard belum split mobile/web |
| **Overall** | **⭐⭐⭐⭐ (3.7/5)** | **Fondasi sangat kuat, butuh polishing** |

---

> **Kesimpulan**: Arsitektur proyek ini sudah mengikuti **best practice Flutter** untuk Clean Architecture dengan pola feature-based. Fondasi DI, Repository Pattern, dan Result Pattern sudah solid. Area utama yang perlu diperbaiki adalah: **(1)** membuat `SessionService` injectable, **(2)** memindahkan business logic dari widget ke provider, dan **(3)** menambahkan routing system dan environment config untuk mendukung skalabilitas.
