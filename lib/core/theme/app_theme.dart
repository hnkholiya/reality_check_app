import 'package:flutter/material.dart';

/// AppTheme — Single source of truth for all colors, typography,
/// component themes, and design tokens used across the app.
class AppTheme {
  AppTheme._(); // Prevent instantiation

  // ─────────────────────────────────────────────
  // 🎨 Brand Color Palette
  // ─────────────────────────────────────────────

  // Primary — Electric Violet (premium feel)
  static const Color primaryColor = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFF9D5FF5);
  static const Color primaryDark = Color(0xFF5B21B6);

  // Accent — Cyan Glow
  static const Color accentColor = Color(0xFF06B6D4);
  static const Color accentLight = Color(0xFF22D3EE);

  // Reality Result Colors
  static const Color safeGreen = Color(0xFF10B981);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color dangerRed = Color(0xFFEF4444);

  static const Color safeGreenDim = Color(0xFF064E3B);
  static const Color warningAmberDim = Color(0xFF78350F);
  static const Color dangerRedDim = Color(0xFF7F1D1D);

  // ── Dark Theme Surfaces ──
  static const Color darkBackground = Color(0xFF0A0A0F);
  static const Color darkSurface = Color(0xFF12121A);
  static const Color darkCard = Color(0xFF1A1A27);
  static const Color darkCardElevated = Color(0xFF22223A);
  static const Color darkBorder = Color(0xFF2E2E4A);
  static const Color darkDivider = Color(0xFF1E1E30);

  // ── Light Theme Surfaces ──
  static const Color lightBackground = Color(0xFFF5F4FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardElevated = Color(0xFFF0EFFE);
  static const Color lightBorder = Color(0xFFE0DCFF);
  static const Color lightDivider = Color(0xFFEDE9FF);

  // ── Text ──
  static const Color darkTextPrimary = Color(0xFFF1F0FF);
  static const Color darkTextSecondary = Color(0xFFA09CB8);
  static const Color darkTextMuted = Color(0xFF6B6880);

  static const Color lightTextPrimary = Color(0xFF1A1033);
  static const Color lightTextSecondary = Color(0xFF5B5375);
  static const Color lightTextMuted = Color(0xFF9590A8);

  // ─────────────────────────────────────────────
  // 📐 Spacing & Radius Tokens
  // ─────────────────────────────────────────────

  static const double radiusSm = 8.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 28.0;
  static const double radiusFull = 100.0;

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // ─────────────────────────────────────────────
  // 🔤 Typography
  // ─────────────────────────────────────────────

  static TextTheme _buildTextTheme(Color primary, Color secondary, Color muted) {
    return TextTheme(
      // Display — Hero headings
      displayLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: primary,
        letterSpacing: -1.2,
        height: 1.1,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -0.8,
        height: 1.2,
      ),
      displaySmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -0.5,
        height: 1.3,
      ),

      // Headline — Section titles
      headlineLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -0.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: -0.2,
      ),
      headlineSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primary,
      ),

      // Title — Card titles, labels
      titleLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: 0.1,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: secondary,
        letterSpacing: 0.1,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: muted,
        letterSpacing: 0.2,
      ),

      // Body — Paragraph text
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: primary,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondary,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: muted,
        height: 1.5,
      ),

      // Label — Buttons, chips, tags
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: 0.5,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: secondary,
        letterSpacing: 0.4,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: muted,
        letterSpacing: 0.6,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // 🌙 DARK THEME
  // ─────────────────────────────────────────────

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: primaryColor,
      primaryContainer: primaryDark,
      secondary: accentColor,
      secondaryContainer: const Color(0xFF0E4F5C),
      surface: darkSurface,
      surfaceContainerHighest: darkCard,
      error: dangerRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: darkTextPrimary,
      onError: Colors.white,
      outline: darkBorder,
      outlineVariant: darkDivider,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkBackground,
      textTheme: _buildTextTheme(
        darkTextPrimary,
        darkTextSecondary,
        darkTextMuted,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: darkTextPrimary),
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: darkTextPrimary,
          letterSpacing: -0.3,
        ),
      ),

      // Card
      cardTheme: CardTheme(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      // Input / TextField
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingMd,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: darkBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: darkBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: dangerRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: dangerRed, width: 2),
        ),
        labelStyle: const TextStyle(color: darkTextSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: darkTextMuted, fontSize: 14),
        errorStyle: const TextStyle(color: dangerRed, fontSize: 11),
        prefixIconColor: darkTextSecondary,
        suffixIconColor: darkTextSecondary,
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryLight,
          side: const BorderSide(color: primaryColor, width: 1.5),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryLight,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: darkCardElevated,
        selectedColor: primaryColor,
        labelStyle: const TextStyle(
          color: darkTextSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
          side: const BorderSide(color: darkBorder),
        ),
        padding: const EdgeInsets.symmetric(horizontal: spacingSm, vertical: spacingXs),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: darkDivider,
        thickness: 1,
        space: 0,
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkTextMuted,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkCardElevated,
        contentTextStyle: const TextStyle(color: darkTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return darkTextMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryDark;
          return darkCard;
        }),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ☀️ LIGHT THEME
  // ─────────────────────────────────────────────

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: primaryColor,
      primaryContainer: const Color(0xFFEDE9FF),
      secondary: accentColor,
      secondaryContainer: const Color(0xFFCFF8FF),
      surface: lightSurface,
      surfaceContainerHighest: lightCard,
      error: dangerRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: lightTextPrimary,
      onError: Colors.white,
      outline: lightBorder,
      outlineVariant: lightDivider,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: lightBackground,
      textTheme: _buildTextTheme(
        lightTextPrimary,
        lightTextSecondary,
        lightTextMuted,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: lightTextPrimary),
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: lightTextPrimary,
          letterSpacing: -0.3,
        ),
      ),

      // Card
      cardTheme: CardTheme(
        color: lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: lightBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      // Input / TextField
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingMd,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: lightBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: lightBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: dangerRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: dangerRed, width: 2),
        ),
        labelStyle: const TextStyle(color: lightTextSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: lightTextMuted, fontSize: 14),
        errorStyle: const TextStyle(color: dangerRed, fontSize: 11),
        prefixIconColor: lightTextSecondary,
        suffixIconColor: lightTextSecondary,
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: lightCardElevated,
        selectedColor: primaryColor,
        labelStyle: const TextStyle(
          color: lightTextSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
          side: const BorderSide(color: lightBorder),
        ),
        padding: const EdgeInsets.symmetric(horizontal: spacingSm, vertical: spacingXs),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: lightDivider,
        thickness: 1,
        space: 0,
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: lightTextMuted,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightCard,
        contentTextStyle: const TextStyle(color: lightTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return lightTextMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withOpacity(0.3);
          }
          return lightBorder;
        }),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // 🛠️ Static Helpers — used in widgets directly
  // ─────────────────────────────────────────────

  /// Returns gradient used on premium cards and backgrounds
  static LinearGradient primaryGradient({bool vertical = false}) {
    return LinearGradient(
      colors: [primaryColor, primaryDark],
      begin: vertical ? Alignment.topCenter : Alignment.centerLeft,
      end: vertical ? Alignment.bottomCenter : Alignment.centerRight,
    );
  }

  /// Glow gradient for hero/result sections
  static LinearGradient glowGradient = const LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Reality result color by key
  static Color resultColor(String result) {
    switch (result.toLowerCase()) {
      case 'safe purchase':
        return safeGreen;
      case 'think before buying':
        return warningAmber;
      case 'better wait':
        return dangerRed;
      default:
        return safeGreen;
    }
  }

  /// Reality result dim background by key (for cards)
  static Color resultColorDim(String result, bool isDark) {
    switch (result.toLowerCase()) {
      case 'safe purchase':
        return isDark ? safeGreenDim : safeGreen.withOpacity(0.1);
      case 'think before buying':
        return isDark ? warningAmberDim : warningAmber.withOpacity(0.1);
      case 'better wait':
        return isDark ? dangerRedDim : dangerRed.withOpacity(0.1);
      default:
        return isDark ? safeGreenDim : safeGreen.withOpacity(0.1);
    }
  }

  /// Shadow for elevated cards
  static List<BoxShadow> cardShadow(bool isDark) => [
    BoxShadow(
      color: isDark
          ? Colors.black.withOpacity(0.4)
          : primaryColor.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  /// Glow shadow for CTA buttons
  static List<BoxShadow> glowShadow = [
    BoxShadow(
      color: primaryColor.withOpacity(0.45),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
  ];
}