# Login Feature Update

## 1. Task: Halaman Login Utama dengan Glassmorphism
**Goal:** Buat halaman login utama (web dan mobile) yang menerapkan tema glassmorphism konsisten dengan dashboard (menggunakan efek backdrop blur).

**Design UI/UX Pro Max Guidelines:**
- **Style:** Glassmorphism (Frosted glass, transparent, blurred background, Z-depth, light reflection, Z-depth).
- **Typography:** Fira Sans untuk Body Text dan Fira Code untuk Headers/Numbers (memberikan kesan dashboard, technical, dan presisi).
- **Efek Wajib:** Backdrop blur (sigma 10-20px), subtle border putih (1px solid dengan opacity 0.2), bayangan lembut untuk efek Z-depth.
- **Logo:** Gunakan asset `assets/images/Oneject-Horizontal.png` di atas form login.

## 2. Pembaruan Tema Warna (Warna Utama)
- **Action:** Update file `lib/core/theme/app_colors.dart` untuk menggunakan kombinasi warna berikut sebagai warna utama (primary, secondary, accent, dll):
  - `#4DA8CF` (Bisa digunakan untuk Primary / Button / Accent)
  - `#5B5856` (Bisa digunakan untuk Text Secondary / Dark borders)
  - `#3F8F81` (Bisa digunakan untuk Success state / Highlights)
- Pastikan warna tersebut diimplementasikan di komponen login page.

## 3. Spesifikasi Implementasi Halaman Login
- **Background:** Gunakan latar belakang yang dinamis, bisa berupa gambar abstrak (jika ada) atau gradien warna utama di atas agar efek blur glassmorphism terlihat mewah.
- **Card Login:**
  - Gunakan `BackdropFilter` dengan `ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15)`.
  - Background color Card: `Colors.white.withValues(alpha: 0.1)` atau `0.08`.
  - Border card: `Border.all(color: Colors.white.withValues(alpha: 0.2))`.
  - BoxShadow: blur radius besar dengan opasitas rendah.
- **Input Fields & Buttons:**
  - Sesuaikan text field agar berpadu dengan tema glass (background transparan atau fill color sangat tipis).
  - Tombol submit/login harus menggunakan warna utama (seperti `#4DA8CF`) dengan efek hover yang mulus (150-300ms transition) dan kursor pointer.

## 4. Notes for Implementer
- Terminal commands: Wajib gunakan `fvm`.
- Untuk referensi widget glassmorphism, bisa cek implementasi di `lib/features/dashboard/ui/widgets/logout_confirmation_dialog.dart` atau `user_header_sidebar.dart`.
- Gunakan tool MCP Dart untuk melihat dokumentasi API jika diperlukan.
- Final step: Jalankan `fvm flutter analyze`. Pastikan tidak ada error atau warning (0 issues).
