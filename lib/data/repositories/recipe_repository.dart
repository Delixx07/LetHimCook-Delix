import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepository(ref.watch(databaseProvider));
});

class RecipeRepository {
  final AppDatabase _db;

  RecipeRepository(this._db);

  Stream<List<Recipe>> watchAllRecipes() {
    return _db.watchAllRecipes();
  }

  Future<Recipe> getRecipe(int id) {
    return _db.getRecipe(id);
  }

  Future<List<Ingredient>> getIngredientsForRecipe(int id) {
    return _db.getIngredientsForRecipe(id);
  }

  Future<List<Step>> getStepsForRecipe(int id) {
    return _db.getStepsForRecipe(id);
  }

  Stream<List<Recipe>> watchFavoriteRecipes() {
    return _db.watchFavoriteRecipes();
  }

  Stream<bool> isFavorite(int id) {
    return _db.isFavorite(id);
  }

  Future<void> toggleFavorite(int id) {
    return _db.toggleFavorite(id);
  }

  Future<int> insertAiRecipe({
    required RecipesCompanion recipe,
    required List<IngredientsCompanion> ingredientList,
    required List<StepsCompanion> stepList,
  }) {
    return _db.insertAiRecipe(
      recipe: recipe,
      ingredientList: ingredientList,
      stepList: stepList,
    );
  }
}
