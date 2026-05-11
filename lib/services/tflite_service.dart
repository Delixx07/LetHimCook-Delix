import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/recipe.dart';

class TfliteService {
  static Interpreter? _interpreter;

  static Future<void> loadModel() async {
    if (_interpreter != null) return;
    try {
      _interpreter = await Interpreter.fromAsset('assets/recipe_classifier.tflite');
    } catch (e) {
      print('Gagal memuat model TFLite: $e');
    }
  }

  /// Memprediksi apakah resep "Sehat" atau "Kurang Sehat" menggunakan TFLite
  /// Fitur: [Sayur (0/1), Daging (0/1), Gorengan (0/1), Manis (0/1), Karbohidrat (0/1)]
  static Future<String> classifyRecipeHealth(Recipe recipe) async {
    await loadModel();
    if (_interpreter == null) return "Unknown";

    final features = _extractFeatures(recipe);
    
    // TFLite input/output shape: [1, 5] -> [1, 1]
    final input = [features];
    final output = List.filled(1, List.filled(1, 0.0));

    _interpreter!.run(input, output);

    final score = output[0][0];
    
    // threshold 0.5 karena sigmoid
    if (score >= 0.5) {
      return "🌱 Kategori : Sehat";
    } else {
      return "⚠️ Kategori : Kurang Sehat (Tinggi Kalori)";
    }
  }

  static List<double> _extractFeatures(Recipe recipe) {
    // 1. Sayur
    bool hasSayur = _checkWords(recipe, ['bayam', 'kangkung', 'wortel', 'kol', 'brokoli', 'tomat', 'sayur']);
    // 2. Daging
    bool hasDaging = _checkWords(recipe, ['ayam', 'daging', 'ikan', 'sapi', 'kambing']);
    // 3. Gorengan
    bool hasGorengan = _checkWords(recipe, ['goreng', 'minyak']);
    // 4. Manis
    bool hasManis = _checkWords(recipe, ['manis', 'gula', 'kecap']);
    // 5. Karbo
    bool hasKarbo = _checkWords(recipe, ['nasi', 'mie', 'kentang', 'tepung']);

    return [
      hasSayur ? 1.0 : 0.0,
      hasDaging ? 1.0 : 0.0,
      hasGorengan ? 1.0 : 0.0,
      hasManis ? 1.0 : 0.0,
      hasKarbo ? 1.0 : 0.0,
    ];
  }

  static bool _checkWords(Recipe recipe, List<String> keywords) {
    final text = (recipe.nama + " " + recipe.bahanUtama.join(" ")).toLowerCase();
    for (final word in keywords) {
      if (text.contains(word)) return true;
    }
    return false;
  }
}
