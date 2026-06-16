import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/recipe_repository.dart';
import '../favorites/favorites_provider.dart';
import '../chatbot/chatbot_screen.dart';
import 'detail_provider.dart';

class DetailScreen extends ConsumerWidget {
  final int recipeId;

  const DetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsyncValue = ref.watch(recipeDetailProvider(recipeId));

    return Scaffold(
      body: detailAsyncValue.when(
        data: (detail) {
          final recipe = detail.recipe;
          final ingredients = detail.ingredients;
          final steps = detail.steps;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'recipe-hero-${recipe.id}',
                    child: Image.asset(
                      recipe.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                backgroundColor: AppTheme.background,
                iconTheme: const IconThemeData(color: Colors.black87),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.smart_toy, color: AppTheme.primary),
                      onPressed: () {
                        final detail = detailAsyncValue.value;
                        if (detail != null) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ChatbotSheet(
                              contextInfo: '${detail.recipe.title}: ${detail.recipe.description}',
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final isFavAsync = ref.watch(isFavoriteProvider(recipe.id));
                      final isFav = isFavAsync.valueOrNull ?? false;
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.black87,
                          ),
                          onPressed: () {
                            ref.read(recipeRepositoryProvider).toggleFavorite(recipe.id);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      Text(
                        recipe.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.text.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingLg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInfoItem(context, Icons.timer, '${recipe.cookTime} mnt'),
                          _buildInfoItem(context, Icons.people, '${recipe.servings} Porsi'),
                          _buildInfoItem(context, Icons.bar_chart, recipe.difficulty),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingLg),
                      const Divider(),
                      const SizedBox(height: AppTheme.spacingMd),
                      Text(
                        'Bahan-bahan',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      ...ingredients.map((ingredient) => Padding(
                        padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                        child: Row(
                          children: [
                            const Icon(Icons.circle, size: 8, color: AppTheme.primary),
                            const SizedBox(width: AppTheme.spacingMd),
                            Expanded(
                              child: Text(
                                ingredient.name,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Text(
                              '${ingredient.amount == ingredient.amount.toInt() ? ingredient.amount.toInt() : ingredient.amount} ${ingredient.unit}',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(height: AppTheme.spacingLg),
                      Text(
                        'Langkah Memasak',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      ...steps.map((step) => Padding(
                        padding: const EdgeInsets.only(bottom: AppTheme.spacingLg),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                              child: Text('${step.stepNumber}'),
                            ),
                            const SizedBox(width: AppTheme.spacingMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    step.instruction,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  if (step.tip != null) ...[
                                    const SizedBox(height: AppTheme.spacingSm),
                                    Container(
                                      padding: const EdgeInsets.all(AppTheme.spacingMd),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.amber.withOpacity(0.3)),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              step.tip!,
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: Colors.brown[800],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
        error: (error, stack) => Center(child: Text('Terjadi kesalahan: $error')),
      ),
      bottomNavigationBar: detailAsyncValue.hasValue
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/cooking/$recipeId'),
                  icon: const Icon(Icons.outdoor_grill),
                  label: const Text('🍳 Mulai Memasak'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primary, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
