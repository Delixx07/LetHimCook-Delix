class Recipe {
  final String nama;
  final String deskripsiSingkat;
  final String waktuMasak;
  final List<String> bahanLengkap;
  final List<String> langkahLangkah;

  Recipe({
    required this.nama,
    required this.deskripsiSingkat,
    required this.waktuMasak,
    required this.bahanLengkap,
    required this.langkahLangkah,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      nama: json['nama']?.toString() ?? 'Tanpa Nama',
      deskripsiSingkat: json['deskripsi_singkat']?.toString() ?? '-',
      waktuMasak: json['waktu_masak']?.toString() ?? '-',
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
}
