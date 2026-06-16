import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../data/database/app_database.dart';

class RecipeDetail {
  final Recipe recipe;
  final List<Ingredient> ingredients;
  final List<Step> steps;

  RecipeDetail({
    required this.recipe,
    required this.ingredients,
    required this.steps,
  });
}

final recipeDetailProvider = FutureProvider.family<RecipeDetail, int>((ref, id) async {
  final repository = ref.watch(recipeRepositoryProvider);
  
  final recipe = await repository.getRecipe(id);
  final ingredients = await repository.getIngredientsForRecipe(id);
  final steps = await repository.getStepsForRecipe(id);
  
  return RecipeDetail(
    recipe: recipe,
    ingredients: ingredients,
    steps: steps,
  );
});
