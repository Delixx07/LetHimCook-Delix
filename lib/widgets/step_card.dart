import 'package:flutter/material.dart' hide Step;
import '../data/database/app_database.dart';
import '../core/theme/app_theme.dart';

class StepCard extends StatelessWidget {
  final Step step;
  final int totalSteps;

  const StepCard({super.key, required this.step, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primary.withOpacity(0.1),
            ),
            child: Text(
              '${step.stepNumber}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            step.instruction,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          if (step.tip != null) ...[
            const SizedBox(height: AppTheme.spacingXl),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step.tip!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.brown[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
