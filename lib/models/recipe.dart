class Recipe {
  final String nama;
  final String deskripsiSingkat;
  final String waktuMasak;
  final List<String> bahanUtama;
  final List<String> bahanLengkap;
  final List<String> langkahLangkah;

  Recipe({
    required this.nama,
    required this.deskripsiSingkat,
    required this.waktuMasak,
    required this.bahanUtama,
    required this.bahanLengkap,
    required this.langkahLangkah,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      nama: json['nama']?.toString() ?? 'Tanpa Nama',
      deskripsiSingkat: json['deskripsi_singkat']?.toString() ?? '-',
      waktuMasak: json['waktu_masak']?.toString() ?? '-',
      bahanUtama:
          (json['bahan_utama'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      bahanLengkap:
          (json['bahan_lengkap'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      langkahLangkah:
          (json['langkah_langkah'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  // Khusus untuk SQLite Database
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'deskripsi_singkat': deskripsiSingkat,
      'waktu_masak': waktuMasak,
      'bahan_utama': bahanUtama.join('|'),
      'bahan_lengkap': bahanLengkap.join('|'),
      'langkah_langkah': langkahLangkah.join('|'),
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      nama: map['nama'],
      deskripsiSingkat: map['deskripsi_singkat'],
      waktuMasak: map['waktu_masak'],
      bahanUtama: (map['bahan_utama'] as String).split('|'),
      bahanLengkap: (map['bahan_lengkap'] as String).split('|'),
      langkahLangkah: (map['langkah_langkah'] as String).split('|'),
    );
  }
}
