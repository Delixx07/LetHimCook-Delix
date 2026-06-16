import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/step_card.dart';
import '../detail/detail_provider.dart';
import '../chatbot/chatbot_screen.dart';
import 'cooking_mode_provider.dart';

class CookingModeScreen extends ConsumerStatefulWidget {
  final int recipeId;

  const CookingModeScreen({super.key, required this.recipeId});

  @override
  ConsumerState<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends ConsumerState<CookingModeScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailAsyncValue = ref.watch(recipeDetailProvider(widget.recipeId));
    final cookingState = ref.watch(cookingProvider(widget.recipeId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: detailAsyncValue.when(
        data: (detail) {
          final steps = detail.steps;
          if (steps.isEmpty) {
            return const Center(child: Text('Tidak ada langkah memasak.'));
          }

          final currentStepIndex = cookingState.currentStep;
          final progress = (currentStepIndex + 1) / steps.length;

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd, vertical: AppTheme.spacingSm),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: AppTheme.spacingSm),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppTheme.primary.withOpacity(0.2),
                            color: AppTheme.primary,
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      Text(
                        '${currentStepIndex + 1} / ${steps.length}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingSm),
                      IconButton(
                        icon: const Icon(Icons.smart_toy, color: AppTheme.primary),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ChatbotSheet(
                              contextInfo: '${detail.recipe.title}: Langkah ke-${currentStepIndex + 1}',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: steps.length,
                    onPageChanged: (index) {
                      ref.read(cookingProvider(widget.recipeId).notifier).setStep(index);
                    },
                    itemBuilder: (context, index) {
                      return StepCard(
                        step: steps[index],
                        totalSteps: steps.length,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: currentStepIndex > 0
                            ? () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: AppTheme.text,
                        ),
                        child: const Icon(Icons.arrow_back),
                      ),
                      if (currentStepIndex < steps.length - 1)
                        ElevatedButton.icon(
                          onPressed: () {
                            ref.read(cookingProvider(widget.recipeId).notifier).markStepCompleted(currentStepIndex);
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Selanjutnya'),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: () {
                            ref.read(cookingProvider(widget.recipeId).notifier).markStepCompleted(currentStepIndex);
                            context.go('/');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('🎉 Selamat, masakan Anda sudah jadi!'),
                                backgroundColor: AppTheme.accent,
                              ),
                            );
                          },
                          icon: const Icon(Icons.celebration),
                          label: const Text('Selesai!'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accent,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
        error: (error, stack) => Center(child: Text('Terjadi kesalahan: $error')),
      ),
    );
  }
}
