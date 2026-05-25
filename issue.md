# Issue: Login Page UI Fixes (Single Image Resolution)

## Task 1 — Align Logo & Caption Evenly (Web & Mobile) [COMPLETED]

**Perubahan yang telah diterapkan:**
- **Web (`login_page_web.dart`):** Padding vertikal diubah menjadi `48`, jarak/gap `SizedBox` antara logo dan teks diubah menjadi `24`, serta `height: 1.5` ditambahkan pada style teks caption agar lebih renggang.
- **Mobile (`login_page_mobile.dart`):** Jarak/gap `SizedBox` antara logo dan teks diubah menjadi `18`, serta `height: 1.5` ditambahkan pada style teks caption.

---

## Task 2 — Perbaiki Gambar Pecah (Single High-Resolution Image)

**Problem:** Gambar logo pecah pada layar high-DPI (Retina/HiDPI) karena file asset yang digunakan memiliki resolusi asli yang terlalu rendah (hanya seukuran display logical-nya).

**Solusi (Menggunakan 1 Gambar Resolusi Tinggi):**
Kita tidak perlu menggunakan folder sub-resolusi `2.0x/` dan `3.0x/`. Cukup gunakan **satu file gambar beresolusi tinggi** langsung di folder utama `assets/images/` dan biarkan Flutter melakukan downscaling secara otomatis dengan kualitas tinggi.

### Langkah-langkah:

1. **Siapkan Gambar High-Res:**
   Ekspor atau buat file logo dengan resolusi asli yang tinggi, misalnya:
   - `Oneject-Vertical.png` → Resolusi asli sekitar **512px × 512px** atau lebih (akan ditampilkan di Web dengan `height: 130`).
   - `Oneject-Logo-Horizontal.png` → Resolusi asli sekitar **512px × 150px** atau lebih (akan ditampilkan di Mobile dengan `height: 70`).

2. **Timpa File Lama:**
   Simpan langsung file beresolusi tinggi tersebut ke:
   - `assets/images/Oneject-Vertical.png`
   - `assets/images/Oneject-Logo-Horizontal.png`

3. **Konfigurasi Kode (Sudah Diterapkan):**
   Di dalam kode, kita sudah menggunakan `filterQuality: FilterQuality.high` pada `Image.asset`. Flutter akan otomatis memperkecil (downscale) gambar beresolusi tinggi tersebut ke ukuran logical (`height: 130` / `height: 70`) dengan filter anti-aliasing berkualitas tinggi, sehingga gambar tetap tajam di layar biasa maupun layar Retina/HiDPI tanpa pecah.

   Contoh kode yang sudah diterapkan:
   ```dart
   Image.asset(
     'assets/images/Oneject-Vertical.png',
     height: 130,
     fit: BoxFit.contain,
     filterQuality: FilterQuality.high, // Menjamin downscaling tetap tajam
     ...
   )
   ```
