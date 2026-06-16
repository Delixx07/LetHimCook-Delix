import 'package:flutter_test/flutter_test.dart';
import 'package:tes_1/core/utils/fuzzy_matcher.dart';
import 'package:tes_1/features/pantry/ingredient_dictionary.dart';

void main() {
  group('FuzzyMatcher.levenshtein', () {
    test('identical strings have distance 0', () {
      expect(FuzzyMatcher.levenshtein('telur', 'telur'), 0);
    });

    test('is case-insensitive', () {
      expect(FuzzyMatcher.levenshtein('Telur', 'telur'), 0);
    });

    test('counts single edits', () {
      expect(FuzzyMatcher.levenshtein('telur', 'telor'), 1); // substitution
      expect(FuzzyMatcher.levenshtein('telur', 'telurr'), 1); // insertion
      expect(FuzzyMatcher.levenshtein('telur', 'telu'), 1); // deletion
    });

    test('empty string distance equals other length', () {
      expect(FuzzyMatcher.levenshtein('', 'nasi'), 4);
      expect(FuzzyMatcher.levenshtein('nasi', ''), 4);
    });
  });

  group('FuzzyMatcher.suggest', () {
    test('suggests correction for a typo', () {
      expect(
        FuzzyMatcher.suggest('bawag merha', kCommonIngredients),
        'bawang merah',
      );
    });

    test('returns null for an exact match', () {
      expect(FuzzyMatcher.suggest('telur', kCommonIngredients), isNull);
    });

    test('returns null when nothing is close enough', () {
      expect(FuzzyMatcher.suggest('xyzqwerty', kCommonIngredients), isNull);
    });

    test('corrects a simple typo for telur', () {
      expect(FuzzyMatcher.suggest('telor', kCommonIngredients), 'telur');
    });
  });
}
