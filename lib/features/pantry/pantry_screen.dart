import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/info_pill.dart';
import 'ai_recipe.dart';
import 'pantry_provider.dart';

class PantryScreen extends ConsumerStatefulWidget {
  const PantryScreen({super.key});

  @override
  ConsumerState<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends ConsumerState<PantryScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addCurrent() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    ref.read(pantryProvider.notifier).addIngredient(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pantryProvider);
    final notifier = ref.read(pantryProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Masak dari Bahan Sisa 🥕'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Punya bahan sisa? Masukkan satu per satu, biar AI carikan resepnya.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.text.withOpacity(0.7),
                      ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'mis. telur, nasi, bawang...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (_) => _addCurrent(),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    CircleAvatar(
                      backgroundColor: AppTheme.primary,
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: _addCurrent,
                      ),
                    ),
                  ],
                ),
                if (state.suggestion != null) ...[
                  const SizedBox(height: AppTheme.spacingSm),
                  _SuggestionBanner(
                    suggestion: state.suggestion!,
                    onAccept: notifier.acceptSuggestion,
                    onDismiss: notifier.dismissSuggestion,
                  ),
                ],
                if (state.ingredients.isNotEmpty) ...[
                  const SizedBox(height: AppTheme.spacingMd),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: state.ingredients
                        .map((ing) => Chip(
                              label: Text(ing),
                              onDeleted: () => notifier.removeIngredient(ing),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              backgroundColor: AppTheme.primary.withOpacity(0.1),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: state.isLoading ? null : notifier.findRecipes,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Carikan Resep dengan AI'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _buildResults(context, state, notifier)),
        ],
      ),
    );
  }

  Widget _buildResults(
      BuildContext context, PantryState state, PantryNotifier notifier) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.primary),
            SizedBox(height: AppTheme.spacingMd),
            Text('AI sedang meracik resep...'),
          ],
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppTheme.hard),
              const SizedBox(height: AppTheme.spacingMd),
              Text(state.error!, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    if (state.results.isEmpty) {
      return EmptyState(
        icon: Icons.kitchen,
        title: state.ingredients.isEmpty ? 'Apa isi kulkasmu?' : 'Siap dimasak!',
        message: state.ingredients.isEmpty
            ? 'Tambahkan bahan sisa di atas, lalu biar AI yang meracik resepnya.'
            : 'Tekan "Carikan Resep dengan AI" untuk dapat rekomendasi.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final recipe = state.results[index];
        return _AiRecipeCard(
          recipe: recipe,
          onTap: () => _showDetail(context, recipe, notifier),
        );
      },
    );
  }

  void _showDetail(
      BuildContext context, AiRecipe recipe, PantryNotifier notifier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AiRecipeDetailSheet(recipe: recipe, notifier: notifier),
    );
  }
}

/// Gentle inline correction shown when an entered ingredient looks like a
/// typo of a known ingredient ("Maksud Anda ...?").
class _SuggestionBanner extends StatelessWidget {
  final IngredientSuggestion suggestion;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  const _SuggestionBanner({
    required this.suggestion,
    required this.onAccept,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: AppTheme.medium.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.medium.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.spellcheck, size: 18, color: AppTheme.medium),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall,
                children: [
                  const TextSpan(text: 'Maksud Anda '),
                  TextSpan(
                    text: '"${suggestion.suggested}"',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(text: '?'),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: onAccept,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Perbaiki'),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close, size: 16),
            color: AppTheme.textMuted,
            visualDensity: VisualDensity.compact,
            tooltip: 'Abaikan',
          ),
        ],
      ),
    );
  }
}

class _AiRecipeCard extends StatelessWidget {
  final AiRecipe recipe;
  final VoidCallback onTap;

  const _AiRecipeCard({required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: AppTheme.cardRadius,
        boxShadow: AppTheme.softShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.auto_awesome,
                          color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Expanded(
                      child: Text(
                        recipe.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSm),
                Text(
                  recipe.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    InfoPill(
                      icon: Icons.timer_outlined,
                      label: '${recipe.cookTime} mnt',
                    ),
                    InfoPill(
                      icon: Icons.bar_chart,
                      label: recipe.difficulty,
                      color: AppTheme.difficultyColor(recipe.difficulty),
                    ),
                    InfoPill(
                      icon: Icons.people_outline,
                      label: '${recipe.servings} porsi',
                      color: AppTheme.accent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AiRecipeDetailSheet extends StatefulWidget {
  final AiRecipe recipe;
  final PantryNotifier notifier;

  const _AiRecipeDetailSheet({required this.recipe, required this.notifier});

  @override
  State<_AiRecipeDetailSheet> createState() => _AiRecipeDetailSheetState();
}

class _AiRecipeDetailSheetState extends State<_AiRecipeDetailSheet> {
  bool _saving = false;
  int? _savedId;

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final id = await widget.notifier.saveRecipe(widget.recipe);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _savedId = id;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resep disimpan ke koleksi!')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              children: [
                Text(
                  recipe.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.text.withOpacity(0.8),
                      ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                Text('Bahan-bahan',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: AppTheme.spacingMd),
                ...recipe.ingredients.map((ing) => Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                      child: Row(
                        children: [
                          const Icon(Icons.circle,
                              size: 8, color: AppTheme.primary),
                          const SizedBox(width: AppTheme.spacingMd),
                          Expanded(child: Text(ing.name)),
                          Text(
                            '${ing.amount == ing.amount.toInt() ? ing.amount.toInt() : ing.amount} ${ing.unit}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: AppTheme.spacingLg),
                Text('Langkah Memasak',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: AppTheme.spacingMd),
                ...recipe.steps.map((step) => Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            child: Text('${step.stepNumber}',
                                style: const TextStyle(fontSize: 12)),
                          ),
                          const SizedBox(width: AppTheme.spacingMd),
                          Expanded(child: Text(step.instruction)),
                        ],
                      ),
                    )),
                const SizedBox(height: 80),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: _savedId != null
                  ? ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push('/recipe/$_savedId');
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text('Lihat di Koleksi'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.bookmark_add_outlined),
                      label: Text(_saving ? 'Menyimpan...' : 'Simpan Resep'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
