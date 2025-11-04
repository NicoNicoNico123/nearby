import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color _primaryColor = Color(0xFF6366F1); // Indigo
  static const Color _secondaryColor = Color(0xFF8B5CF6); // Violet
  static const Color _backgroundColor = Color(0xFF0F0F0F); // Almost black
  static const Color _surfaceColor = Color(0xFF1A1A1A); // Dark gray
  static const Color _cardColor = Color(0xFF252525); // Medium dark gray
  static const Color _onSurfaceColor = Color(0xFFFFFFFF); // White
  static const Color _errorColor = Color(0xFFEF4444); // Red
  static const Color _successColor = Color(0xFF10B981); // Green
  static const Color _warningColor = Color(0xFFF59E0B); // Amber

  // Text Colors
  static const Color _textPrimary = Color(0xFFFFFFFF);
  static const Color _textSecondary = Color(0xFF9CA3AF);
  static const Color _textTertiary = Color(0xFF6B7280);

  // Border & Divider
  static const Color _borderColor = Color(0xFF374151);
  static const Color _dividerColor = Color(0xFF1F2937);

  // Spacing
  static const double _spacingXS = 4.0;
  static const double _spacingSM = 8.0;
  static const double _spacingMD = 16.0;
  static const double _spacingLG = 24.0;
  static const double _spacingXL = 32.0;
  static const double _spacingXXL = 48.0;

  // Border Radius
  static const double _radiusSM = 4.0;
  static const double _radiusMD = 8.0;
  static const double _radiusLG = 12.0;
  static const double _radiusXL = 16.0;
  static const double _radiusXXL = 24.0;

  // Typography
  static const String _fontFamily = 'Inter';

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: _fontFamily,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _surfaceColor,
        error: _errorColor,
        onPrimary: _onSurfaceColor,
        onSecondary: _onSurfaceColor,
        onSurface: _onSurfaceColor,
        onError: _onSurfaceColor,
        surfaceContainerHighest: _cardColor,
        onSurfaceVariant: _textSecondary,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _surfaceColor,
        foregroundColor: _textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
        ),
        iconTheme: IconThemeData(
          color: _textPrimary,
          size: 24,
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: _cardColor,
        elevation: 2,
        margin: EdgeInsets.symmetric(
          horizontal: _spacingMD,
          vertical: _spacingSM,
        ),
      ),
      cardColor: _cardColor,

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: _onSurfaceColor,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: _spacingLG,
            vertical: _spacingMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusMD),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: _spacingLG,
            vertical: _spacingMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusMD),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: _fontFamily,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          side: const BorderSide(color: _primaryColor, width: 1),
          padding: const EdgeInsets.symmetric(
            horizontal: _spacingLG,
            vertical: _spacingMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusMD),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: _fontFamily,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMD),
          borderSide: const BorderSide(color: _borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMD),
          borderSide: const BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMD),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMD),
          borderSide: const BorderSide(color: _errorColor),
        ),
        labelStyle: const TextStyle(
          color: _textSecondary,
          fontFamily: _fontFamily,
        ),
        hintStyle: const TextStyle(
          color: _textTertiary,
          fontFamily: _fontFamily,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: _spacingMD,
          vertical: _spacingMD,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: _textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: _fontFamily,
        ),
        displayMedium: TextStyle(
          color: _textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: _fontFamily,
        ),
        displaySmall: TextStyle(
          color: _textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
        ),
        headlineLarge: TextStyle(
          color: _textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
        ),
        headlineMedium: TextStyle(
          color: _textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
        ),
        headlineSmall: TextStyle(
          color: _textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
        ),
        titleLarge: TextStyle(
          color: _textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
        ),
        titleMedium: TextStyle(
          color: _textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
        ),
        titleSmall: TextStyle(
          color: _textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
        ),
        bodyLarge: TextStyle(
          color: _textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          fontFamily: _fontFamily,
        ),
        bodyMedium: TextStyle(
          color: _textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          fontFamily: _fontFamily,
        ),
        bodySmall: TextStyle(
          color: _textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          fontFamily: _fontFamily,
        ),
        labelLarge: TextStyle(
          color: _textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
        ),
        labelMedium: TextStyle(
          color: _textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
        ),
        labelSmall: TextStyle(
          color: _textTertiary,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _surfaceColor,
        selectedItemColor: _primaryColor,
        unselectedItemColor: _textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          fontFamily: _fontFamily,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: _textPrimary,
        size: 24,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: _dividerColor,
        thickness: 1,
        space: 1,
      ),

      // List Tile Theme
      listTileTheme: const ListTileThemeData(
        iconColor: _textPrimary,
        textColor: _textPrimary,
        tileColor: _cardColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: _spacingMD,
          vertical: _spacingSM,
        ),
      ),
    );
  }

  // Static spacing constants for use throughout the app
  static const double spacingXS = _spacingXS;
  static const double spacingSM = _spacingSM;
  static const double spacingMD = _spacingMD;
  static const double spacingLG = _spacingLG;
  static const double spacingXL = _spacingXL;
  static const double spacingXXL = _spacingXXL;

  // Static border radius constants
  static const double radiusSM = _radiusSM;
  static const double radiusMD = _radiusMD;
  static const double radiusLG = _radiusLG;
  static const double radiusXL = _radiusXL;
  static const double radiusXXL = _radiusXXL;

  // Static color constants
  static const Color primaryColor = _primaryColor;
  static const Color secondaryColor = _secondaryColor;
  static const Color backgroundColor = _backgroundColor;
  static const Color surfaceColor = _surfaceColor;
  static const Color cardColor = _cardColor;
  static const Color errorColor = _errorColor;
  static const Color successColor = _successColor;
  static const Color warningColor = _warningColor;
  static const Color textPrimary = _textPrimary;
  static const Color textSecondary = _textSecondary;
  static const Color textTertiary = _textTertiary;
  static const Color borderColor = _borderColor;
  static const Color dividerColor = _dividerColor;
}