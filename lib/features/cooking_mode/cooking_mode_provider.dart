import 'package:flutter_riverpod/flutter_riverpod.dart';

class CookingState {
  final int currentStep;
  final Set<int> completedSteps;

  CookingState({
    required this.currentStep,
    required this.completedSteps,
  });

  CookingState copyWith({
    int? currentStep,
    Set<int>? completedSteps,
  }) {
    return CookingState(
      currentStep: currentStep ?? this.currentStep,
      completedSteps: completedSteps ?? this.completedSteps,
    );
  }
}

class CookingNotifier extends StateNotifier<CookingState> {
  CookingNotifier() : super(CookingState(currentStep: 0, completedSteps: {}));

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void markStepCompleted(int step) {
    final newCompleted = Set<int>.from(state.completedSteps)..add(step);
    state = state.copyWith(completedSteps: newCompleted);
  }
}

final cookingProvider = StateNotifierProvider.family<CookingNotifier, CookingState, int>((ref, recipeId) {
  return CookingNotifier();
});
