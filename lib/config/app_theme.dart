import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// PTG App Theme - Extracted from Figma Material Theme
///
/// This theme is based on the Material Theme tokens defined in the Figma design.
/// Font families: Oswald (headings/labels), Roboto (body text)
/// Primary accent: Teal/Cyan (#9CF1F0)
class AppTheme {
  AppTheme._();

  // ============================================================================
  // COLOR PALETTE - Extracted from Figma
  // ============================================================================

  /// Primary accent color - Teal/Cyan
  static const Color primaryColor = Color(0xFF9CF1F0);

  /// Secondary color - Dark Teal
  static const Color secondaryColor = Color(0xFF4A6363);

  /// Background colors
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFF5F5F5);

  /// Text colors
  static const Color onPrimaryColor = Color(0xFF000000);
  static const Color onSecondaryColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF1A1A1A);
  static const Color textSecondaryColor = Color(0xFF4A6363);

  /// Stroke/Border color
  static const Color strokeColor = Color(0xFFFFFFFF);

  // ============================================================================
  // SPACING & RADIUS - Extracted from Figma
  // ============================================================================

  /// Card border radius (16px)
  static const double cardRadius = 16.0;

  /// Button border radius (25px)
  static const double buttonRadius = 25.0;

  /// Default padding
  static const double defaultPadding = 16.0;

  /// Small padding
  static const double smallPadding = 8.0;

  // ============================================================================
  // COLOR SCHEME
  // ============================================================================

  static ColorScheme get colorScheme => const ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: onPrimaryColor,
    secondary: secondaryColor,
    onSecondary: onSecondaryColor,
    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),
    surface: surfaceColor,
    onSurface: textPrimaryColor,
  );

  // ============================================================================
  // TEXT THEME - Based on Material Theme tokens from Figma
  // ============================================================================

  /// Material Theme Typography extracted from Figma
  ///
  /// Figma tokens mapped to Flutter TextTheme:
  /// - material-theme/display/large → displayLarge (Oswald, 57px)
  /// - material-theme/display/medium → displayMedium (Oswald, 45px)
  /// - material-theme/display/small → displaySmall (Oswald, 36px)
  /// - material-theme/headline/large → headlineLarge (Oswald, 32px)
  /// - material-theme/headline/medium → headlineMedium (Oswald, 28px)
  /// - material-theme/headline/small → headlineSmall (Oswald, 24px)
  /// - material-theme/title/large → titleLarge (Oswald, 22px, 400)
  /// - material-theme/title/medium → titleMedium (Oswald, 16px, 500)
  /// - material-theme/title/small → titleSmall (Oswald, 14px, 500)
  /// - material-theme/body/large → bodyLarge (Roboto, 16px)
  /// - material-theme/body/medium → bodyMedium (Roboto, 14px)
  /// - material-theme/body/small → bodySmall (Roboto, 12px)
  /// - material-theme/label/large → labelLarge (Oswald, 14px, 500)
  /// - material-theme/label/medium → labelMedium (Oswald, 12px, 500)
  /// - material-theme/label/small → labelSmall (Oswald, 11px, 500)
  static TextTheme get textTheme => TextTheme(
    // Display styles - Oswald
    displayLarge: GoogleFonts.oswald(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
      color: textPrimaryColor,
    ),
    displayMedium: GoogleFonts.oswald(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
      color: textPrimaryColor,
    ),
    displaySmall: GoogleFonts.oswald(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
      color: textPrimaryColor,
    ),

    // Headline styles - Oswald
    headlineLarge: GoogleFonts.oswald(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.25,
      color: textPrimaryColor,
    ),
    headlineMedium: GoogleFonts.oswald(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.29,
      color: textPrimaryColor,
    ),
    headlineSmall: GoogleFonts.oswald(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.33,
      color: textPrimaryColor,
    ),

    // Title styles - Oswald (from Figma: material-theme/title/*)
    titleLarge: GoogleFonts.oswald(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.27,
      color: textPrimaryColor,
    ),
    titleMedium: GoogleFonts.oswald(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.5,
      color: textPrimaryColor,
    ),
    titleSmall: GoogleFonts.oswald(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      color: textPrimaryColor,
    ),

    // Body styles - Roboto (from Figma: material-theme/body/*)
    bodyLarge: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.5,
      color: textPrimaryColor,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
      color: textPrimaryColor,
    ),
    bodySmall: GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
      color: textSecondaryColor,
    ),

    // Label styles - Oswald (from Figma: material-theme/label/*)
    labelLarge: GoogleFonts.oswald(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      color: textPrimaryColor,
    ),
    labelMedium: GoogleFonts.oswald(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
      color: textPrimaryColor,
    ),
    labelSmall: GoogleFonts.oswald(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
      color: textPrimaryColor,
    ),
  );

  // ============================================================================
  // COMPONENT THEMES
  // ============================================================================

  /// Card theme with 16px border radius
  static CardThemeData get cardTheme => CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(cardRadius),
    ),
    color: backgroundColor,
  );

  /// Elevated button theme with 25px border radius
  static ElevatedButtonThemeData get elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: GoogleFonts.oswald(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      );

  /// Outlined button theme
  static OutlinedButtonThemeData get outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          side: const BorderSide(color: secondaryColor, width: 2),
          textStyle: GoogleFonts.oswald(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      );

  /// Text button theme
  static TextButtonThemeData get textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: secondaryColor,
      textStyle: GoogleFonts.oswald(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    ),
  );

  /// Input decoration theme
  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: surfaceColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(cardRadius),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(cardRadius),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(cardRadius),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(cardRadius),
      borderSide: const BorderSide(color: Color(0xFFB00020), width: 1),
    ),
    labelStyle: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: textSecondaryColor,
    ),
    hintStyle: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: textSecondaryColor.withValues(alpha: 0.6),
    ),
  );

  /// AppBar theme
  static AppBarTheme get appBarTheme => AppBarTheme(
    backgroundColor: backgroundColor,
    foregroundColor: textPrimaryColor,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.oswald(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      color: textPrimaryColor,
    ),
  );

  /// Bottom navigation bar theme
  static BottomNavigationBarThemeData get bottomNavigationBarTheme =>
      BottomNavigationBarThemeData(
        backgroundColor: backgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        selectedLabelStyle: GoogleFonts.oswald(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.oswald(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
      );

  // ============================================================================
  // COMPLETE THEME DATA
  // ============================================================================

  /// Light theme for the PTG app
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    cardTheme: cardTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    textButtonTheme: textButtonTheme,
    inputDecorationTheme: inputDecorationTheme,
    appBarTheme: appBarTheme,
    bottomNavigationBarTheme: bottomNavigationBarTheme,
    scaffoldBackgroundColor: backgroundColor,
    dividerColor: textSecondaryColor.withValues(alpha: 0.2),
  );

  /// Dark theme for the PTG app (optional - based on the design)
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: Color(0xFF000000),
      secondary: Color(0xFF9CF1F0),
      onSecondary: Color(0xFF000000),
      error: Color(0xFFCF6679),
      onError: Color(0xFF000000),
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFFFFFFF),
    ),
    textTheme: textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    cardTheme: cardTheme.copyWith(color: const Color(0xFF2D2D2D)),
    elevatedButtonTheme: elevatedButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    textButtonTheme: textButtonTheme,
    inputDecorationTheme: inputDecorationTheme.copyWith(
      fillColor: const Color(0xFF2D2D2D),
    ),
    appBarTheme: appBarTheme.copyWith(
      backgroundColor: const Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
      backgroundColor: const Color(0xFF1E1E1E),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    dividerColor: Colors.white.withValues(alpha: 0.2),
  );
}
