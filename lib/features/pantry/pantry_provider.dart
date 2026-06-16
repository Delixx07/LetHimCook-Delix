import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/fuzzy_matcher.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/recipe_repository.dart';
import 'ai_recipe.dart';
import 'ingredient_dictionary.dart';

/// A pending typo suggestion: the user typed [original], which looks like a
/// misspelling of the known ingredient [suggested].
class IngredientSuggestion {
  final String original;
  final String suggested;

  const IngredientSuggestion({required this.original, required this.suggested});
}

/// State for the pantry feature: the ingredients the user has entered and the
/// AI's recommendation request status.
class PantryState {
  final List<String> ingredients;
  final bool isLoading;
  final String? error;
  final List<AiRecipe> results;
  final IngredientSuggestion? suggestion;

  const PantryState({
    this.ingredients = const [],
    this.isLoading = false,
    this.error,
    this.results = const [],
    this.suggestion,
  });

  PantryState copyWith({
    List<String>? ingredients,
    bool? isLoading,
    String? error,
    bool clearError = false,
    List<AiRecipe>? results,
    IngredientSuggestion? suggestion,
    bool clearSuggestion = false,
  }) {
    return PantryState(
      ingredients: ingredients ?? this.ingredients,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      results: results ?? this.results,
      suggestion: clearSuggestion ? null : (suggestion ?? this.suggestion),
    );
  }
}

class PantryNotifier extends StateNotifier<PantryState> {
  PantryNotifier(this._repository) : super(const PantryState());

  final RecipeRepository _repository;

  // Provide at build/run time:
  //   flutter run --dart-define=GROQ_API_KEY=your_key_here
  static const String _apiKey =
      String.fromEnvironment('GROQ_API_KEY', defaultValue: '');
  static const String _endpoint =
      'https://api.groq.com/openai/v1/chat/completions';

  void addIngredient(String raw) {
    final name = raw.trim();
    if (name.isEmpty) return;
    final exists = state.ingredients
        .any((e) => e.toLowerCase() == name.toLowerCase());
    if (exists) {
      state = state.copyWith(clearSuggestion: true);
      return;
    }

    // Add the ingredient as typed, but if it looks like a typo of a known
    // ingredient, surface a gentle correction the user can accept or dismiss.
    final corrected = FuzzyMatcher.suggest(name, kCommonIngredients);
    final alreadyHasCorrection = corrected != null &&
        state.ingredients.any((e) => e.toLowerCase() == corrected.toLowerCase());

    state = state.copyWith(
      ingredients: [...state.ingredients, name],
      suggestion: (corrected != null && !alreadyHasCorrection)
          ? IngredientSuggestion(original: name, suggested: corrected)
          : null,
      clearSuggestion: corrected == null || alreadyHasCorrection,
    );
  }

  /// Replaces the originally-typed ingredient with the suggested correction.
  void acceptSuggestion() {
    final s = state.suggestion;
    if (s == null) return;
    final updated = state.ingredients
        .map((e) => e == s.original ? s.suggested : e)
        .toList();
    state = state.copyWith(ingredients: updated, clearSuggestion: true);
  }

  void dismissSuggestion() {
    state = state.copyWith(clearSuggestion: true);
  }

  void removeIngredient(String name) {
    final removingSuggested =
        state.suggestion != null && state.suggestion!.original == name;
    state = state.copyWith(
      ingredients: state.ingredients.where((e) => e != name).toList(),
      clearSuggestion: removingSuggested,
    );
  }

  void clearResults() {
    state = state.copyWith(results: [], clearError: true);
  }

  Future<void> findRecipes() async {
    if (state.ingredients.isEmpty) return;
    if (_apiKey.isEmpty) {
      state = state.copyWith(
        error: 'API key belum dikonfigurasi. Jalankan dengan '
            '--dart-define=GROQ_API_KEY=...',
      );
      return;
    }
    state = state.copyWith(isLoading: true, clearError: true, results: []);

    final bahan = state.ingredients.join(', ');

    final systemMessage = {
      "role": "system",
      "content":
          "Kamu adalah koki ahli masakan Indonesia. Berdasarkan bahan sisa yang "
              "dimiliki user, buatkan 3 rekomendasi resep yang realistis. "
              "Kamu boleh menambahkan bumbu dapur umum (garam, minyak, bawang, dll). "
              "Balas HANYA dengan JSON valid tanpa teks lain, tanpa markdown code block. "
              "Format: {\"recipes\":[{\"title\":string,\"description\":string,"
              "\"cookTime\":number_menit,\"difficulty\":\"Mudah\"|\"Sedang\"|\"Sulit\","
              "\"servings\":number,\"ingredients\":[{\"name\":string,\"amount\":number,"
              "\"unit\":string}],\"steps\":[string]}]}. Gunakan Bahasa Indonesia."
    };

    final userMessage = {
      "role": "user",
      "content": "Bahan yang saya punya: $bahan. Berikan rekomendasi resepnya."
    };

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "llama-3.1-8b-instant",
          "messages": [systemMessage, userMessage],
          "temperature": 0.6,
          "max_tokens": 2048,
          "response_format": {"type": "json_object"},
        }),
      );

      if (response.statusCode != 200) {
        final errorMsg =
            jsonDecode(response.body)['error']?['message'] ?? response.body;
        state = state.copyWith(
          isLoading: false,
          error: 'Gagal (${response.statusCode}): $errorMsg',
        );
        return;
      }

      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'] as String;
      final parsed = jsonDecode(content);
      final list = (parsed['recipes'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(AiRecipe.fromJson)
          .toList();

      if (list.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'AI tidak menemukan resep yang cocok. Coba bahan lain.',
        );
        return;
      }

      state = state.copyWith(isLoading: false, results: list);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Terjadi kesalahan. Periksa koneksi internet. ($e)',
      );
    }
  }

  /// Saves an AI recipe to the local database and returns its new id.
  Future<int> saveRecipe(AiRecipe recipe) {
    return _repository.insertAiRecipe(
      recipe: RecipesCompanion(
        title: Value(recipe.title),
        description: Value(recipe.description),
        // AI recipes have no bundled image; the card/detail fall back to a
        // placeholder when this asset is missing.
        imageAsset: const Value('assets/images/ai_recipe.jpg'),
        cookTime: Value(recipe.cookTime),
        difficulty: Value(recipe.difficulty),
        servings: Value(recipe.servings),
        source: const Value('ai'),
      ),
      ingredientList: recipe.ingredients
          .map((i) => IngredientsCompanion(
                name: Value(i.name),
                amount: Value(i.amount),
                unit: Value(i.unit),
              ))
          .toList(),
      stepList: recipe.steps
          .map((s) => StepsCompanion(
                stepNumber: Value(s.stepNumber),
                instruction: Value(s.instruction),
              ))
          .toList(),
    );
  }
}

final pantryProvider =
    StateNotifierProvider<PantryNotifier, PantryState>((ref) {
  return PantryNotifier(ref.watch(recipeRepositoryProvider));
});
