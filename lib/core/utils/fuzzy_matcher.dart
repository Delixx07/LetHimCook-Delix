/// Lightweight fuzzy string matching utilities used to catch typos when the
/// user enters ingredient names (e.g. "bawag merha" -> "bawang merah").
class FuzzyMatcher {
  /// Computes the Levenshtein edit distance between [a] and [b]: the minimum
  /// number of single-character insertions, deletions, or substitutions needed
  /// to turn one string into the other. Comparison is case-insensitive.
  static int levenshtein(String a, String b) {
    a = a.toLowerCase().trim();
    b = b.toLowerCase().trim();
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    // Two-row dynamic programming to keep memory at O(min(a, b)).
    var prev = List<int>.generate(b.length + 1, (i) => i);
    var curr = List<int>.filled(b.length + 1, 0);

    for (var i = 0; i < a.length; i++) {
      curr[0] = i + 1;
      for (var j = 0; j < b.length; j++) {
        final cost = a[i] == b[j] ? 0 : 1;
        curr[j + 1] = _min3(
          curr[j] + 1, // insertion
          prev[j + 1] + 1, // deletion
          prev[j] + cost, // substitution
        );
      }
      final tmp = prev;
      prev = curr;
      curr = tmp;
    }
    return prev[b.length];
  }

  /// Returns a similarity ratio in [0, 1] derived from the edit distance.
  /// 1.0 means identical; 0.0 means completely different.
  static double similarity(String a, String b) {
    final maxLen = a.length > b.length ? a.length : b.length;
    if (maxLen == 0) return 1.0;
    return 1.0 - levenshtein(a, b) / maxLen;
  }

  /// Finds the closest entry in [candidates] to [input].
  ///
  /// Returns the best candidate only when it is *similar but not identical* to
  /// the input — i.e. a likely typo worth suggesting. Returns `null` when the
  /// input already matches a candidate exactly, or when nothing is close
  /// enough (controlled by [threshold], a minimum similarity ratio).
  static String? suggest(
    String input,
    Iterable<String> candidates, {
    double threshold = 0.7,
  }) {
    final normalized = input.toLowerCase().trim();
    if (normalized.isEmpty) return null;

    String? best;
    var bestScore = 0.0;

    for (final candidate in candidates) {
      final score = similarity(normalized, candidate.toLowerCase());
      // Exact match -> no correction needed.
      if (score >= 0.999) return null;
      if (score > bestScore) {
        bestScore = score;
        best = candidate;
      }
    }

    if (best != null && bestScore >= threshold) return best;
    return null;
  }

  static int _min3(int a, int b, int c) {
    final m = a < b ? a : b;
    return m < c ? m : c;
  }
}
