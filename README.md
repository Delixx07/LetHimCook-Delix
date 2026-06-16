# LetHimCook 🍳 — Interactive Recipe Book & AI Cooking Assistant

**LetHimCook** adalah aplikasi buku resep interaktif sekaligus asisten memasak berbasis **Flutter**. Aplikasi ini menggabungkan koleksi resep lokal yang tersimpan secara *offline-first* dengan kecerdasan buatan (AI) untuk dua hal: (1) menjawab pertanyaan seputar masakan lewat chatbot, dan (2) **merekomendasikan resep dari bahan sisa yang kamu punya**.

> Dibangun dengan arsitektur *feature-first* yang bersih, database lokal Drift (SQLite), state management Riverpod, dan UI yang dirancang profesional.

### ⚡ Quick Start

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define=GROQ_API_KEY=your_groq_key
```

> Repositori: [github.com/Delixx07/LetHimCook-Delix](https://github.com/Delixx07/LetHimCook-Delix)

---

## Daftar Isi

1. [Fitur Utama](#fitur-utama)
2. [Tangkapan Alur Aplikasi](#tangkapan-alur-aplikasi)
3. [Arsitektur](#arsitektur)
4. [Struktur Direktori](#struktur-direktori)
5. [Teknologi & Dependensi](#teknologi--dependensi)
6. [Model Data & Database](#model-data--database)
7. [Integrasi AI](#integrasi-ai)
8. [Koreksi Typo Bahan (Fuzzy Matching)](#koreksi-typo-bahan-fuzzy-matching)
9. [Desain & Theming](#desain--theming)
10. [Navigasi & Routing](#navigasi--routing)
11. [Cara Menjalankan](#cara-menjalankan)
12. [Konfigurasi API Key](#konfigurasi-api-key)
13. [Pengujian](#pengujian)
14. [Catatan Pengembangan](#catatan-pengembangan)

---

## Fitur Utama

| Fitur | Deskripsi |
|-------|-----------|
| 📖 **Katalog Resep** | Koleksi resep masakan Indonesia yang tersimpan lokal, ditampilkan dalam *staggered/masonry grid* dengan kartu bergambar. |
| 🔎 **Detail Resep** | Halaman detail dengan gambar *hero animation*, daftar bahan lengkap beserta takaran, dan langkah memasak bernomor disertai tips. |
| 🍳 **Mode Memasak (Cooking Mode)** | Panduan memasak langkah-demi-langkah secara *immersive* (full-screen). Layar tetap menyala (*wakelock*) agar tidak mati saat tangan kotor. |
| 🥕 **Masak dari Bahan Sisa (AI)** | **Fitur unggulan.** Masukkan bahan sisa yang kamu punya, lalu AI akan membuat **3 rekomendasi resep** lengkap (bahan + langkah) yang realistis. |
| ✏️ **Koreksi Typo (Fuzzy/Levenshtein)** | Saat mengetik bahan, aplikasi mendeteksi salah ketik dengan jarak *Levenshtein* dan menawarkan koreksi ("Maksud Anda: *bawang merah*?"). |
| 💾 **Simpan Resep AI** | Resep hasil rekomendasi AI dapat disimpan ke database lokal dan langsung terintegrasi penuh dengan katalog, detail, favorit, dan mode memasak. |
| 🤖 **Chatbot Asisten Koki** | Asisten AI "LetHimCook AI" yang siap menjawab pertanyaan seputar masakan, dengan konteks resep yang sedang dibuka. |
| ❤️ **Favorit** | Tandai resep kesukaan (termasuk resep AI) untuk akses cepat. |
| 📴 **Offline-First** | Seluruh data resep tersimpan lokal lewat SQLite. Hanya fitur AI yang membutuhkan koneksi internet. |

---

## Tangkapan Alur Aplikasi

**Alur fitur "Masak dari Bahan Sisa":**

```
Tab "Dapur"
   │
   ├─ Tambah bahan satu per satu  ──►  chip bahan (bisa dihapus)
   │
   ├─ Tekan "Carikan Resep dengan AI"
   │        │
   │        ▼
   │   AI (Groq) mengembalikan 3 resep dalam JSON terstruktur
   │
   ├─ Hasil tampil sebagai kartu resep (judul, deskripsi, waktu, kesulitan, porsi)
   │
   ├─ Tap kartu  ──►  bottom sheet detail penuh (bahan + langkah)
   │
   └─ Tombol "Simpan Resep"  ──►  tersimpan ke DB lokal
            │
            └─ "Lihat di Koleksi"  ──►  buka seperti resep biasa
```

---

## Arsitektur

Aplikasi mengikuti pola **feature-first clean architecture** dengan pemisahan lapisan yang jelas:

```
┌─────────────────────────────────────────────┐
│                   UI Layer                    │
│   (features/*/*_screen.dart, widgets/)        │
└───────────────────┬───────────────────────────┘
                    │  watch / read
┌───────────────────▼───────────────────────────┐
│              State Layer (Riverpod)            │
│   (features/*/*_provider.dart, StateNotifier)  │
└───────────────────┬───────────────────────────┘
                    │  panggil method
┌───────────────────▼───────────────────────────┐
│               Repository Layer                 │
│        (data/repositories/*.dart)              │
└───────────────────┬───────────────────────────┘
                    │  query
┌───────────────────▼───────────────────────────┐
│          Data Layer (Drift / SQLite)           │
│   (data/database/*.dart) + AI Service (HTTP)   │
└────────────────────────────────────────────────┘
```

**Prinsip:**
- UI tidak pernah memanggil database secara langsung — selalu lewat provider → repository.
- Setiap fitur berdiri sendiri di dalam foldernya (screen + provider + model bila perlu).
- Kode reusable (kartu, badge, empty state, theme) diletakkan di `widgets/` dan `core/`.

---

## Struktur Direktori

```
lib/
├── main.dart                         # Entry point + ProviderScope + MaterialApp.router
│
├── core/                             # Hal lintas-fitur
│   ├── theme/
│   │   └── app_theme.dart            # Palet warna, tipografi, theme komponen terpusat
│   ├── router/
│   │   └── app_router.dart           # GoRouter + bottom nav shell (Eksplor/Dapur/Favorit)
│   └── utils/
│       └── fuzzy_matcher.dart        # Levenshtein + saran koreksi typo
│
├── data/                             # Lapisan data
│   ├── database/
│   │   ├── app_database.dart         # Definisi tabel Drift + migrasi + query
│   │   ├── app_database.g.dart       # (generated) jangan diedit manual
│   │   └── seed_data.dart            # Data resep bawaan (seed)
│   └── repositories/
│       └── recipe_repository.dart    # Abstraksi akses data resep
│
├── features/                         # Setiap fitur berdiri sendiri
│   ├── main/
│   │   └── main_screen.dart          # Scaffold utama + NavigationBar + FAB chatbot
│   ├── catalog/                      # Tab Eksplor
│   │   ├── catalog_screen.dart
│   │   └── catalog_provider.dart
│   ├── detail/                       # Halaman detail resep
│   │   ├── detail_screen.dart
│   │   └── detail_provider.dart
│   ├── cooking_mode/                 # Mode memasak immersive
│   │   ├── cooking_mode_screen.dart
│   │   └── cooking_mode_provider.dart
│   ├── favorites/                    # Tab Favorit
│   │   ├── favorites_screen.dart
│   │   └── favorites_provider.dart
│   ├── chatbot/                      # Asisten AI (bottom sheet)
│   │   ├── chatbot_screen.dart
│   │   └── chatbot_provider.dart
│   └── pantry/                       # Tab Dapur — Masak dari Bahan Sisa (AI)
│       ├── pantry_screen.dart        # UI input bahan + kartu hasil + detail sheet
│       ├── pantry_provider.dart      # State + panggilan AI + koreksi typo + simpan
│       ├── ai_recipe.dart            # Model parsing JSON dari AI
│       └── ingredient_dictionary.dart # Daftar kanonik bahan untuk fuzzy matching
│
└── widgets/                          # Komponen UI reusable
    ├── recipe_card.dart              # Kartu resep (gambar + badge kesulitan + AI)
    ├── step_card.dart                # Kartu langkah di cooking mode
    ├── empty_state.dart              # Tampilan kosong yang konsisten
    └── info_pill.dart                # Badge kecil (waktu/porsi/kesulitan)
```

---

## Teknologi & Dependensi

| Kategori | Paket | Kegunaan |
|----------|-------|----------|
| **Framework** | `flutter` (SDK ^3.9.2) | Kerangka aplikasi |
| **Database** | `drift`, `drift_flutter`, `sqlite3_flutter_libs` | ORM SQLite type-safe + storage lokal |
| **State Management** | `flutter_riverpod` | Manajemen state reaktif |
| **Navigasi** | `go_router` | Routing deklaratif + stateful shell (bottom nav) |
| **UI** | `flutter_staggered_grid_view` | Layout masonry grid untuk katalog |
| **Font** | *bundled assets* | Playfair Display & DM Sans di-*bundle* (`assets/fonts/`) agar tampil tanpa internet |
| **AI / Network** | `http` | Memanggil API Groq (OpenAI-compatible) |
| **Utilitas** | `wakelock_plus` | Mencegah layar mati saat mode memasak |
| **Dev** | `build_runner`, `drift_dev` | Code generation untuk Drift |
| **Dev** | `flutter_lints` | Aturan lint |

---

## Model Data & Database

Database menggunakan **Drift** (SQLite) dengan `schemaVersion = 3`. Empat tabel utama:

### Tabel `Recipes`
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | int (PK, auto) | ID resep |
| `title` | text | Nama resep |
| `description` | text | Deskripsi singkat |
| `imageAsset` | text | Path gambar di assets |
| `cookTime` | int | Waktu memasak (menit) |
| `difficulty` | text | `Mudah` / `Sedang` / `Sulit` |
| `servings` | int | Jumlah porsi |
| `source` | text | `seed` (bawaan) atau `ai` (hasil AI) — *default `seed`* |

### Tabel `Ingredients`
`id`, `recipeId` (FK), `name`, `amount` (real), `unit`.

### Tabel `Steps`
`id`, `recipeId` (FK), `stepNumber`, `instruction`, `tip` (nullable).

### Tabel `FavoriteRecipes`
`recipeId` (PK, FK) — menandai resep favorit.

### Riwayat Migrasi
- **v1 → v2:** menambah tabel `FavoriteRecipes`.
- **v2 → v3:** menambah kolom `source` pada `Recipes` untuk membedakan resep bawaan dengan resep hasil AI.

> **Penting:** Resep hasil AI disimpan ke tabel `Recipes` yang sama (ditandai `source = 'ai'`). Dengan begitu, resep AI otomatis muncul di katalog, bisa difavoritkan, dibuka detailnya, dan dimasak lewat cooking mode — **tanpa duplikasi logika apa pun**.

---

## Integrasi AI

Aplikasi menggunakan **Groq API** (endpoint kompatibel-OpenAI) dengan model `llama-3.1-8b-instant`.

### 1. Chatbot Asisten Koki — `features/chatbot/chatbot_provider.dart`
- Mengirim riwayat percakapan + *system prompt* berkepribadian "LetHimCook AI".
- Mendukung *context injection*: saat dibuka dari halaman detail, konteks resep ikut dikirim agar jawaban relevan.
- Jawaban berupa teks bebas (Bahasa Indonesia).

### 2. Rekomendasi dari Bahan Sisa — `features/pantry/pantry_provider.dart`
- Mengirim daftar bahan user dengan instruksi ketat untuk membalas **HANYA JSON valid**.
- Menggunakan `response_format: {"type": "json_object"}` agar output terstruktur.
- Format JSON yang diminta:
  ```json
  {
    "recipes": [
      {
        "title": "string",
        "description": "string",
        "cookTime": 30,
        "difficulty": "Mudah|Sedang|Sulit",
        "servings": 2,
        "ingredients": [{ "name": "string", "amount": 2, "unit": "string" }],
        "steps": ["langkah 1", "langkah 2"]
      }
    ]
  }
  ```
- JSON di-*parse* menjadi objek `AiRecipe` (lihat `ai_recipe.dart`), yang punya konversi tipe defensif (mis. angka berupa string tetap aman di-parse).
- Penanganan error mencakup: status non-200, JSON kosong, dan kegagalan koneksi.

---

## Koreksi Typo Bahan (Fuzzy Matching)

Agar rekomendasi AI tidak meleset gara-gara salah ketik, input bahan dilengkapi koreksi typo berbasis **jarak Levenshtein**.

- **`core/utils/fuzzy_matcher.dart`** — implementasi jarak Levenshtein (DP dua baris, O(min(a,b)) memori), rasio kemiripan `similarity()`, dan `suggest()` yang mencari kandidat terdekat.
- **`features/pantry/ingredient_dictionary.dart`** — daftar kanonik bahan dapur umum Indonesia sebagai acuan pencocokan.
- **Cara kerja:** saat user menambahkan bahan, sistem menghitung kemiripan terhadap daftar kanonik. Jika ada yang *mirip tapi tidak persis sama* (di atas ambang `threshold = 0.7`), muncul banner halus **"Maksud Anda …?"** yang bisa di-**Perbaiki** (mengganti otomatis) atau di-**Abaikan**.
- **Contoh:** `"bawag merha"` → menyarankan `"bawang merah"`; `"telor"` → `"telur"`.
- **Pengujian:** logika ini diuji di [`test/fuzzy_matcher_test.dart`](test/fuzzy_matcher_test.dart).

---

## Desain & Theming

Seluruh gaya visual dipusatkan di [`lib/core/theme/app_theme.dart`](lib/core/theme/app_theme.dart).

- **Tipografi:** `Playfair Display` (judul, kesan elegan) + `DM Sans` (teks isi), di-*bundle* sebagai font asset di `assets/fonts/` sehingga tampil konsisten tanpa koneksi internet.
- **Palet:** latar krem hangat (`#FBF7F2`), aksen oranye (`#FF6B35`), hijau (`#4E9A51`), dengan warna kesulitan terpisah (hijau/kuning/merah).
- **Komponen terpusat:** tema untuk `Card`, `Chip`, `InputDecoration`, `NavigationBar`, `SnackBar`, dan `ElevatedButton` didefinisikan di theme agar konsisten di seluruh layar.
- **Sentuhan profesional:** gradient brand, *soft shadow* berlapis, radius konsisten, *gradient scrim* pada gambar kartu agar teks tetap terbaca, dan badge kesulitan berwarna.
- **Komponen reusable:** `EmptyState` (tampilan kosong) dan `InfoPill` (badge metadata) menjaga keseragaman.

---

## Navigasi & Routing

Menggunakan `go_router` dengan `StatefulShellRoute.indexedStack` (mempertahankan state tiap tab):

| Rute | Layar | Keterangan |
|------|-------|------------|
| `/` | Catalog | Tab **Eksplor** |
| `/pantry` | Pantry | Tab **Dapur** (Masak dari Bahan Sisa) |
| `/favorites` | Favorites | Tab **Favorit** |
| `/recipe/:id` | Detail | Detail resep (push) |
| `/cooking/:id` | Cooking Mode | Mode memasak immersive (push) |

Tombol **FAB** di setiap tab membuka **Chatbot** sebagai bottom sheet.

---

## Cara Menjalankan

### Prasyarat
- Flutter SDK (Dart ^3.9.2)
- Koneksi internet (untuk fitur AI)

### Langkah

1. **Pasang dependensi**
   ```bash
   flutter pub get
   ```

2. **Generate kode Drift**
   Karena database memakai code generation, jalankan `build_runner`:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **(Opsional) Tambahkan gambar resep**
   Resep bawaan memakai gambar di `assets/images/`. Pastikan file berikut tersedia (jika tidak, kartu akan menampilkan *fallback* gradient otomatis):
   - `nasi_goreng.jpg`, `ayam_bakar.jpg`, `gado_gado.jpg`, `soto_ayam.jpg`, `es_teler.jpg`

4. **Jalankan aplikasi** (sertakan API key agar fitur AI aktif)
   ```bash
   flutter run --dart-define=GROQ_API_KEY=your_groq_key
   ```
   Untuk memilih perangkat tertentu: `flutter run -d <device_id> --dart-define=GROQ_API_KEY=...`
   (lihat daftar perangkat dengan `flutter devices`).

---

## Konfigurasi API Key

Fitur AI (chatbot & rekomendasi bahan sisa) membutuhkan **Groq API key**. Demi keamanan, key **tidak disimpan di dalam source code** — melainkan dibaca dari *compile-time environment* lewat `--dart-define`:

```bash
flutter run --dart-define=GROQ_API_KEY=your_key_here
```

Di dalam kode, key dibaca dengan `const String.fromEnvironment('GROQ_API_KEY')` (lihat `chatbot_provider.dart` dan `pantry_provider.dart`). Jika key kosong, fitur AI akan menampilkan pesan yang memberi tahu cara mengonfigurasinya.

> Dapatkan API key gratis di [console.groq.com](https://console.groq.com).

---

## Pengujian

Logika koreksi typo (Levenshtein) memiliki *unit test*:

```bash
flutter test
```

Berkas uji: [`test/fuzzy_matcher_test.dart`](test/fuzzy_matcher_test.dart) — mencakup perhitungan jarak edit, kemiripan, dan saran koreksi (mis. `"bawag merha"` → `"bawang merah"`).

---

## Catatan Pengembangan

- **Jangan mengedit** file `*.g.dart` secara manual — file itu dihasilkan oleh `build_runner`. Setiap kali mengubah definisi tabel di `app_database.dart`, jalankan ulang `build_runner` dan naikkan `schemaVersion` bila perlu disertai langkah migrasi.
- **Resep AI tanpa gambar** memakai placeholder; `errorBuilder` pada `Image.asset` menampilkan gradient fallback secara mulus.
- **Konsistensi gaya:** gunakan konstanta dari `AppTheme` (warna, spacing, radius) alih-alih nilai literal agar tampilan tetap seragam.

---

*Dibangun dengan ❤️ menggunakan Flutter.*
