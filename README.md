# 🔥 LetHimCook — AI Recipe Recommender

**LetHimCook** adalah aplikasi mobile berbasis Flutter yang memanfaatkan kecerdasan buatan (AI) untuk merekomendasikan resep masakan berdasarkan bahan-bahan yang dimiliki pengguna. Cukup masukkan bahan yang ada di dapur, pilih bahan yang ingin digunakan, dan biarkan AI meracik resep terbaik untuk kamu!

---

## ✨ Fitur Utama

| Fitur | Deskripsi |
|---|---|
| 🧑‍🍳 **Rekomendasi Resep AI** | Menggunakan Groq API (LLaMA 3.3 70B) untuk menghasilkan 3 rekomendasi resep lengkap |
| ✅ **Pilih Bahan dengan Checkbox** | Tambahkan bahan ke daftar, lalu centang bahan mana saja yang ingin digunakan |
| 📝 **Langkah Memasak Detail** | Setiap resep dilengkapi 5-8 langkah memasak detail bergaya Cookpad |
| 🎨 **UI Modern & Gelap** | Tampilan dark theme yang elegan dengan palet warna kustom |
| 🔥 **Loading "LET HIM COOK..."** | Animasi loading yang unik saat AI sedang memproses resep |

---

## 🎨 Palet Warna

| Nama | Warna | Hex Code |
|---|---|---|
| Primary Dark | 🟦 | `#203A56` |
| Secondary Blue | 🔵 | `#587893` |
| Accent Teal | 🩵 | `#95CED3` |
| Button Mint | 🟢 | `#98F6CD` |

---

## 📱 Alur Aplikasi

```
InputScreen → ResultScreen → DetailScreen
```

1. **InputScreen** — Pengguna mengetik dan menambahkan bahan makanan ke daftar. Bahan yang sudah ditambahkan bisa dicentang/tidak dicentang untuk menentukan bahan mana yang akan digunakan.
2. **ResultScreen** — Menampilkan 3 kartu rekomendasi resep dari AI, lengkap dengan nama resep, deskripsi singkat, dan estimasi waktu memasak.
3. **DetailScreen** — Menampilkan detail resep yang dipilih: daftar bahan lengkap beserta takaran, dan langkah-langkah memasak yang detail dan berurutan.

---

## 🏗️ Struktur Proyek (Tree)

```
lib/
├── main.dart                    # Entry point & konfigurasi tema aplikasi
├── models/
│   └── recipe.dart              # Model data Recipe (nama, bahan, langkah, dll)
├── screens/
│   ├── input_screen.dart        # Halaman input & pemilihan bahan
│   ├── result_screen.dart       # Halaman daftar rekomendasi resep
│   └── detail_screen.dart       # Halaman detail resep (bahan + langkah)
└── services/
    └── ai_service.dart          # Service untuk komunikasi dengan Groq API
```

### Penjelasan Setiap File

| File | Deskripsi |
|---|---|
| `main.dart` | Konfigurasi `MaterialApp`, pengaturan `ThemeData` dengan palet warna kustom, dan routing ke `InputScreen` |
| `models/recipe.dart` | Data class `Recipe` dengan factory `fromJson()` untuk parsing respons JSON dari AI dengan handling tipe data yang robust |
| `screens/input_screen.dart` | UI untuk menambah bahan ke daftar persisten, memilih bahan via checkbox, dan tombol "Cari Resep" yang memanggil AI |
| `screens/result_screen.dart` | Menampilkan daftar resep hasil rekomendasi AI dalam bentuk kartu yang bisa di-tap untuk melihat detail |
| `screens/detail_screen.dart` | Menampilkan detail lengkap resep dengan `CustomScrollView`, badge info (waktu, jumlah bahan, jumlah langkah), daftar bahan, dan langkah memasak bernomor |
| `services/ai_service.dart` | Mengirim request ke Groq REST API dengan prompt engineering untuk menghasilkan resep detail bergaya Cookpad |

---

## 🛠️ Teknologi yang Digunakan

- **Flutter** — Framework UI cross-platform
- **Dart** — Bahasa pemrograman
- **Groq API** — Backend AI (model: `llama-3.3-70b-versatile`)
- **HTTP Package** — Untuk REST API calls (`http: ^1.2.1`)

---

## 🚀 Cara Menjalankan

### Prasyarat
- Flutter SDK (≥ 3.9.2)
- Groq API Key (gratis di [console.groq.com](https://console.groq.com))

### Langkah-langkah

1. **Clone repository**
   ```bash
   git clone https://github.com/Delixx07/LetHimCook.git
   cd LetHimCook
   ```

2. **Masukkan API Key**
   Buka file `lib/services/ai_service.dart` dan ganti placeholder:
   ```dart
   static const String _apiKey = 'YOUR_GROQ_API_KEY';
   ```
   dengan API Key kamu dari [Groq Console](https://console.groq.com).

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8
  http: ^1.2.1

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^5.0.0
```

---

## 👨‍💻 Kontributor

- **Delixx07** — Developer

---

## 📄 Lisensi

Proyek ini dibuat untuk keperluan akademik (Tugas Mata Kuliah PBB).
