# 🔥 LetHimCook — On-Device AI Recipe Recommender

**LetHimCook** adalah aplikasi mobile berbasis Flutter yang dirancang sebagai asisten masak cerdas dengan pendekatan **100% Offline-First**. Aplikasi ini dapat mencari resep secara cerdas dari bahan yang kamu miliki, mengklasifikasikan tingkat kesehatan resep menggunakan *Machine Learning* secara *on-device*, dan menyimpan resep favoritmu ke dalam database lokal tanpa memerlukan koneksi internet!

---

## ✨ Fitur Utama

| Fitur | Deskripsi |
|---|---|
| 🧠 **On-Device AI Classification** | Menggunakan **TensorFlow Lite (TFLite)** secara *offline* untuk memprediksi apakah suatu resep termasuk kategori "Sehat" atau "Kurang Sehat" berdasarkan komposisinya. |
| 🔍 **Smart Recipe Matching** | Mencari resep dari database lokal menggunakan algoritma kecocokan ketat (*strict match*) & toleransi *typo* (`string_similarity`). |
| 💖 **Favorite & Local Database** | Menyimpan resep masakan favorit ke dalam penyimpanan lokal secara permanen menggunakan **SQLite** (`sqflite`). |
| ✅ **Pilih Bahan dengan Checkbox** | Tambahkan bahan ke daftar, lalu centang bahan mana saja yang ingin digunakan. AI menolak resep jika bahan kurang terlalu banyak. |
| 🎨 **UI Modern & Gelap** | Tampilan *dark theme* yang elegan dengan palet warna kustom. |

---

## 📱 Alur Aplikasi

```text
InputScreen → ResultScreen → DetailScreen
                 ↳ FavoriteScreen
```

1. **InputScreen** — Pengguna mengetik dan menambahkan bahan makanan ke daftar. AI akan memilah kombinasi resep terbaik berdasarkan bahan yang dicentang.
2. **ResultScreen** — Menampilkan daftar rekomendasi resep yang relevan berdasarkan tingkat kecocokan bahan (*Missing Ingredients Filter*).
3. **DetailScreen** — Menampilkan detail resep. Di sini **TFLite** akan bekerja langsung menganalisis resep, dan pengguna bisa menekan tombol 💖 untuk menyimpannya.
4. **FavoriteScreen** — Layar khusus yang memuat semua resep favorit pengguna yang ditarik secara dinamis dari database SQLite.

---

## 🏗️ Struktur Proyek (Tree)

```text
lib/
├── main.dart                    # Entry point & konfigurasi tema aplikasi
├── models/
│   └── recipe.dart              # Model data Recipe (termasuk SQLite toMap/fromMap)
├── screens/
│   ├── input_screen.dart        # Halaman input & pemilihan bahan
│   ├── result_screen.dart       # Halaman daftar rekomendasi resep
│   ├── detail_screen.dart       # Halaman detail resep (TFLite Scanner & Favorite)
│   └── favorite_screen.dart     # Halaman daftar resep favorit pengguna
└── services/
    ├── ai_service.dart          # Algoritma smart matching resep ke database JSON
    ├── tflite_service.dart      # Integrasi model TensorFlow Lite (.tflite)
    └── db_service.dart          # Integrasi CRUD SQLite untuk fitur favorit
assets/
├── recipes.json                 # Offline database berisi 40+ resep Nusantara
└── recipe_classifier.tflite     # Model Machine Learning hasil konversi ke TFLite
```

---

## 🚀 Cara Menjalankan

### Prasyarat
- Flutter SDK (≥ 3.9.2)
- Karena aplikasi ini memuat *package* Native (C++/NDK) seperti `tflite_flutter` dan `sqflite`, sangat disarankan untuk menjalankan aplikasi pada *real device* Android/iOS atau Emulator yang terkonfigurasi dengan baik.

### Langkah-langkah

1. **Clone repository**
   ```bash
   git clone https://github.com/Delixx07/LetHimCook.git
   cd LetHimCook
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

> **Catatan:** Semua layanan berjalan 100% secara OFFLINE. Kamu tidak perlu mengatur API Key sama sekali!

---

## 📷 Dokumentasi
*(Catatan: Tangkapan layar di bawah mungkin merupakan versi UI sebelumnya)*

### Input Screen
<img width="474" height="1020" alt="image" src="https://github.com/user-attachments/assets/8459f047-aacb-4ae9-a20f-7a82ce4c83f7" />

### Loading Screen
<img width="470" height="1027" alt="image" src="https://github.com/user-attachments/assets/54eef8e5-a7c4-46c8-ae22-dcef80b274cb" />

### Result Screen
<img width="470" height="1028" alt="image" src="https://github.com/user-attachments/assets/9b8ec9a8-e5cc-4a72-84eb-6e74909ceb4a" />

### Detail Screen
<img width="473" height="1022" alt="image" src="https://github.com/user-attachments/assets/f7e6ad65-35aa-4cfd-ad2d-0e70359775e0" />
<img width="465" height="1036" alt="image" src="https://github.com/user-attachments/assets/221404ea-1a8d-4018-8db7-52bd0a01bcd8" />
