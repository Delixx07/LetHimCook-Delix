import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../data/database/app_database.dart';

final favoriteRecipesProvider = StreamProvider<List<Recipe>>((ref) {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.watchFavoriteRecipes();
});

final isFavoriteProvider = StreamProvider.family<bool, int>((ref, recipeId) {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.isFavorite(recipeId);
});
