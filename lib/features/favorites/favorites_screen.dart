import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/recipe_card.dart';
import '../../widgets/empty_state.dart';
import 'favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteRecipesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Resep Favorit')),
      body: favoritesAsync.when(
        data: (recipes) {
          if (recipes.isEmpty) {
            return const EmptyState(
              icon: Icons.favorite_border,
              title: 'Belum ada favorit',
              message: 'Tandai resep yang kamu suka, dan akan muncul di sini.',
            );
          }
          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: AppTheme.spacingMd,
            crossAxisSpacing: AppTheme.spacingMd,
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return RecipeCard(
                recipe: recipe,
                onTap: () => context.push('/recipe/${recipe.id}'),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primary),
        ),
        error: (error, stack) => Center(
          child: Text('Terjadi kesalahan: $error'),
        ),
      ),
    );
  }
}
