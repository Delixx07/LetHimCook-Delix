import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'seed_data.dart';

part 'app_database.g.dart';

class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get imageAsset => text()();
  IntColumn get cookTime => integer()();
  TextColumn get difficulty => text()();
  IntColumn get servings => integer()();
  // 'seed' for bundled recipes, 'ai' for AI-generated ones.
  TextColumn get source => text().withDefault(const Constant('seed'))();
}

class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId => integer().references(Recipes, #id)();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get unit => text()();
}

class Steps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId => integer().references(Recipes, #id)();
  IntColumn get stepNumber => integer()();
  TextColumn get instruction => text()();
  TextColumn get tip => text().nullable()();
}

class FavoriteRecipes extends Table {
  IntColumn get recipeId => integer().references(Recipes, #id)();
  
  @override
  Set<Column> get primaryKey => {recipeId};
}

@DriftDatabase(tables: [Recipes, Ingredients, Steps, FavoriteRecipes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Seed data
        final seedData = SeedData();
        for (var recipe in seedData.recipes) {
          final recipeId = await into(recipes).insert(recipe.companion);
          
          for (var ingredient in recipe.ingredients) {
            await into(ingredients).insert(ingredient.copyWith(recipeId: Value(recipeId)));
          }
          
          for (var step in recipe.steps) {
            await into(steps).insert(step.copyWith(recipeId: Value(recipeId)));
          }
        }
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(favoriteRecipes);
        }
        if (from < 3) {
          await m.addColumn(recipes, recipes.source);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'lethimcook_db');
  }

  Stream<List<Recipe>> watchAllRecipes() => select(recipes).watch();
  Future<Recipe> getRecipe(int id) => (select(recipes)..where((tbl) => tbl.id.equals(id))).getSingle();
  Future<List<Ingredient>> getIngredientsForRecipe(int id) => (select(ingredients)..where((tbl) => tbl.recipeId.equals(id))).get();
  Future<List<Step>> getStepsForRecipe(int id) => (select(steps)..where((tbl) => tbl.recipeId.equals(id))
    ..orderBy([(t) => OrderingTerm(expression: t.stepNumber)])).get();

  Stream<List<Recipe>> watchFavoriteRecipes() {
    final query = select(recipes).join([
      innerJoin(favoriteRecipes, favoriteRecipes.recipeId.equalsExp(recipes.id))
    ]);
    return query.watch().map((rows) => rows.map((row) => row.readTable(recipes)).toList());
  }

  Stream<bool> isFavorite(int id) {
    return (select(favoriteRecipes)..where((tbl) => tbl.recipeId.equals(id)))
        .watch()
        .map((rows) => rows.isNotEmpty);
  }

  /// Inserts an AI-generated recipe together with its ingredients and steps,
  /// then returns the new recipe id.
  Future<int> insertAiRecipe({
    required RecipesCompanion recipe,
    required List<IngredientsCompanion> ingredientList,
    required List<StepsCompanion> stepList,
  }) async {
    return transaction(() async {
      final recipeId = await into(recipes).insert(recipe);
      for (final ing in ingredientList) {
        await into(ingredients).insert(ing.copyWith(recipeId: Value(recipeId)));
      }
      for (final step in stepList) {
        await into(steps).insert(step.copyWith(recipeId: Value(recipeId)));
      }
      return recipeId;
    });
  }

  Future<void> toggleFavorite(int id) async {
    final exists = await (select(favoriteRecipes)..where((tbl) => tbl.recipeId.equals(id))).getSingleOrNull();
    if (exists != null) {
      await (delete(favoriteRecipes)..where((tbl) => tbl.recipeId.equals(id))).go();
    } else {
      await into(favoriteRecipes).insert(FavoriteRecipesCompanion(recipeId: Value(id)));
    }
  }
}
