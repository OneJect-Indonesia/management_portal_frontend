# Enhancement: Dashboard Honeycomb Menu

## Backstory
- Dashboard sudah terbuat dan berjalan tanpa error.

## Target
- Menu dashboard enhancement

## Problem
- Terdapat error untuk honeycomb logo: `Unable to load asset: 'assets/images/Oneject-Vertical.png' The asset does not exist or has empty data.`

## Goals
- Cari tahu masalah pada problem di atas dan perbaiki (pastikan gambar benar-benar ada di direktori `assets/images/`, cek penulisan di `pubspec.yaml`, dan jalankan `fvm flutter clean` lalu `fvm flutter pub get` jika perlu).
- Sedikit perbesar ukuran honeycomb (`hexSize` pada `HoneycombMenu`).
- Pastikan ketika user hover widget honeycomb dia akan:
  - Scale up (membesar).
  - Beri shadow (bayangan).
  - Perbesar ratio `backdrop-filter: blur`-nya agar efek glassmorphism lebih terlihat.
- Berikan animasi ketika load pertama, honeycomb muncul dari tengah belakang (dari posisi honeycomb logo/center) menuju ke posisi grid mereka masing-masing secara dinamis/staggered.

## Note
- Cari library yang mendukung terlebih dahulu (contoh: `flutter_staggered_animations` atau manfaatkan `TweenAnimationBuilder` / `AnimationController` bawaan Flutter untuk efek memunculkan dari tengah).
- Gunakan `fvm` untuk command terminal.
- Gunakan MCP Dart dan 7context untuk mencari dokumentasi yang sesuai.
- Pastikan ketika selesai tidak ada error sama sekali.
