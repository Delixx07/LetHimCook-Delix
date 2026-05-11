import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:string_similarity/string_similarity.dart';
import '../models/recipe.dart';

class AiService {
  static List<Recipe>? _cachedRecipes;

  /// Load database resep dari assets
  static Future<List<Recipe>> _loadRecipeDatabase() async {
    if (_cachedRecipes != null) return _cachedRecipes!;

    final jsonStr = await rootBundle.loadString('assets/recipes.json');
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    _cachedRecipes =
        jsonList
            .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
            .toList();
    return _cachedRecipes!;
  }

  /// Cari resep berdasarkan bahan yang dipilih user
  static Future<List<Recipe>> getRecipeRecommendations(
    List<String> ingredients,
  ) async {
    final allRecipes = await _loadRecipeDatabase();
    final userIngredients =
        ingredients.map((e) => e.toLowerCase().trim()).toSet();

    final scored = <_ScoredRecipe>[];

    for (final recipe in allRecipes) {
      final recipeBahan =
          recipe.bahanUtama.map((e) => e.toLowerCase().trim()).toSet();

      int matched = 0;
      int missing = 0;

      for (final rb in recipeBahan) {
        bool isPunya = false;
        final rbWords = rb.split(' '); 
        
        for (final userBahan in userIngredients) {
          if (rb == userBahan || userBahan.similarityTo(rb) > 0.85) {
            isPunya = true;
            break;
          }
          for (final word in rbWords) {
            if (word == userBahan || userBahan.similarityTo(word) > 0.85) {
              isPunya = true;
              break;
            }
          }
          if (isPunya) break;
        }

        if (isPunya) {
          matched++;
        } else {
          missing++;
        }
      }

      // STRICT MODE: Hanya izinkan resep jika bahan yang kurang (missing) MAKSIMAL 1 atau 2.
      // Jadi kalau cuma punya ayam & nasi, dan soto ayam butuh 5 bahan (kurang 3), soto ayam akan DITOLAK.
      if (matched > 0 && missing <= 2) {
        double matchPercentage = matched / recipeBahan.length;
        double score = (matchPercentage * 100) - (missing * 50);

        scored.add(_ScoredRecipe(recipe: recipe, score: score, matched: matched, missing: missing));
      }
    }

    scored.sort((a, b) {
      int matchedCompare = b.matched.compareTo(a.matched);
      if (matchedCompare != 0) return matchedCompare;
      
      return a.missing.compareTo(b.missing);
    });

    return scored.take(3).map((s) => s.recipe).toList();
  }
}

class _ScoredRecipe {
  final Recipe recipe;
  final double score;
  final int matched;
  final int missing;

  _ScoredRecipe({
    required this.recipe,
    required this.score,
    required this.matched,
    required this.missing,
  });
}
