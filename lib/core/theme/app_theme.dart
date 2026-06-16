import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Bundled font families (declared in pubspec.yaml). Using local assets
  // instead of google_fonts so the app works fully offline.
  static const String _serif = 'PlayfairDisplay';
  static const String _sans = 'DMSans';

  static TextStyle _playfair({Color? color, FontWeight? weight, double? height}) =>
      TextStyle(
        fontFamily: _serif,
        color: color,
        fontWeight: weight,
        height: height,
      );

  static TextStyle _dmSans(
          {Color? color, FontWeight? weight, double? height, double? size}) =>
      TextStyle(
        fontFamily: _sans,
        color: color,
        fontWeight: weight,
        height: height,
        fontSize: size,
      );

  // Core palette
  static const Color background = Color(0xFFFBF7F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF3ECE3);
  static const Color text = Color(0xFF2C1A0E);
  static const Color textMuted = Color(0xFF8A7B6E);
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryDark = Color(0xFFE2541F);
  static const Color accent = Color(0xFF4E9A51);
  static const Color border = Color(0xFFEDE3D8);

  // Difficulty colors
  static const Color easy = Color(0xFF4E9A51);
  static const Color medium = Color(0xFFE6A100);
  static const Color hard = Color(0xFFD0432B);

  static Color difficultyColor(String difficulty) {
    final d = difficulty.toLowerCase();
    if (d.contains('mudah')) return easy;
    if (d.contains('sulit')) return hard;
    return medium;
  }

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;

  // Radii
  static final BorderRadius cardRadius = BorderRadius.circular(20.0);
  static final BorderRadius chipRadius = BorderRadius.circular(12.0);
  static final BorderRadius buttonRadius = BorderRadius.circular(16.0);

  // Brand gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF8559), primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF2C1A0E).withOpacity(0.04),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF2C1A0E).withOpacity(0.06),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static ThemeData get lightTheme {
    final base = ColorScheme.light(
      primary: primary,
      secondary: accent,
      surface: surface,
      onSurface: text,
      onPrimary: Colors.white,
      surfaceContainerHighest: surfaceAlt,
      outlineVariant: border,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: base,
      splashFactory: InkSparkle.splashFactory,
      textTheme: TextTheme(
        displayLarge: _playfair(color: text, weight: FontWeight.bold),
        displayMedium: _playfair(color: text, weight: FontWeight.bold),
        displaySmall: _playfair(color: text, weight: FontWeight.bold),
        headlineLarge: _playfair(color: text, weight: FontWeight.w700),
        headlineMedium: _playfair(color: text, weight: FontWeight.w600),
        headlineSmall: _playfair(color: text, weight: FontWeight.w600),
        titleLarge: _playfair(color: text, weight: FontWeight.w600),
        titleMedium: _dmSans(color: text, weight: FontWeight.w600),
        titleSmall: _dmSans(color: text, weight: FontWeight.w600),
        bodyLarge: _dmSans(color: text, height: 1.45),
        bodyMedium: _dmSans(color: text, height: 1.45),
        bodySmall: _dmSans(color: textMuted),
        labelLarge: _dmSans(color: text, weight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: _playfair(color: text, weight: FontWeight.bold)
            .copyWith(fontSize: 26),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: cardRadius),
        elevation: 0,
        color: surface,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceAlt,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: chipRadius),
        labelStyle: _dmSans(color: text, weight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: _dmSans(color: textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        elevation: 0,
        height: 68,
        indicatorColor: primary.withOpacity(0.14),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return _dmSans(
            size: 12,
            weight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? primary : textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? primary : textMuted);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: spacingLg, vertical: spacingMd),
          shape: RoundedRectangleBorder(borderRadius: buttonRadius),
          textStyle: _dmSans(weight: FontWeight.bold, size: 16),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: text,
        contentTextStyle: _dmSans(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1),
    );
  }
}
