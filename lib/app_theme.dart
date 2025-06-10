import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const int _m3PrimaryValue = 0xFF6750A4;

enum AppColorSeed {
  baseColor(
    'Baseline',
    MaterialColor(_m3PrimaryValue, <int, Color>{
      50: Color(0xFFEADDFF),
      100: Color(0xFFD0BCFF),
      200: Color(0xFFB69DF8),
      300: Color(0xFF9A7EEA),
      400: Color(0xFF7F67D9),
      500: Color(_m3PrimaryValue),
      600: Color(0xFF5D4896),
      700: Color(0xFF4F3C7E),
      800: Color(0xFF413168),
      900: Color(0xFF332551),
    }),
  ),
  mintGreen(
    'Mint Green',
    MaterialColor(0xFF98FB98, <int, Color>{
      50: Color(0xFFE6FFFA),
      100: Color(0xFFC0FFEE),
      200: Color(0xFF98FB98),
      300: Color(0xFF70F2A0),
      400: Color(0xFF52EAA0),
      500: Color(0xFF38E298),
      600: Color(0xFF30D08A),
      700: Color(0xFF28BA7A),
      800: Color(0xFF20A86C),
      900: Color(0xFF108A52),
    }),
  ),
  skyBlue(
    'Sky Blue',
    MaterialColor(0xFF87CEEB, <int, Color>{
      50: Color(0xFFE1F5FE),
      100: Color(0xFFB3E5FC),
      200: Color(0xFF81D4FA),
      300: Color(0xFF4FC3F7),
      400: Color(0xFF29B6F6),
      500: Color(0xFF03A9F4),
      600: Color(0xFF039BE5),
      700: Color(0xFF0288D1),
      800: Color(0xFF0277BD),
      900: Color(0xFF01579B),
    }),
  ),
  softPink(
    'Soft Pink',
    MaterialColor(0xFFFFC0CB, <int, Color>{
      50: Color(0xFFFFE4E8),
      100: Color(0xFFFFCCD5),
      200: Color(0xFFFFB3BF),
      300: Color(0xFFFFA0AB),
      400: Color(0xFFFF8D9A),
      500: Color(0xFFFF7A87),
      600: Color(0xFFFF6A70),
      700: Color(0xFFFF5C67),
      800: Color(0xFFF84B5C),
      900: Color(0xFFF02D40),
    }),
  ),
  lightLavender(
    'Light Lavender',
    MaterialColor(0xFFB2A2E8, <int, Color>{
      50: Color(0xFFF3F0FF),
      100: Color(0xFFE0DBFA),
      200: Color(0xFFCEC4F6),
      300: Color(0xFFBCAEF1),
      400: Color(0xFFB2A2E8), // 0xFFB2A2E8 - Our Seed
      500: Color(0xFFA08CE0),
      600: Color(0xFF8E7ACA),
      700: Color(0xFF7C69B3),
      800: Color(0xFF6A589D),
      900: Color(0xFF584786),
    }),
  ),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  amber('Amber', Colors.amber),
  lime('Lime', Colors.lime),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink),
  purple('Purple', Colors.purple),
  red('Red', Colors.red);

  const AppColorSeed(this.label, this.color);
  final String label;
  final MaterialColor color;

  static Color getColor(String label) {
    return AppColorSeed.values
        .firstWhere(
          (e) => e.label == label,
          orElse: () => AppColorSeed.baseColor,
        )
        .color;
  }

  static String getLabel(Color color) {
    return AppColorSeed.values
        .firstWhere(
          (e) => e.color == color,
          orElse: () => AppColorSeed.baseColor,
        )
        .label;
  }

  static AppColorSeed getSeedByLabel(String label) {
    return AppColorSeed.values.firstWhere(
      (e) => e.label == label,
      orElse: () => AppColorSeed.baseColor,
    );
  }
}

class AppTheme {
  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Brightness brightness,
  }) {
    final textTheme = GoogleFonts.poppinsTextTheme(
      ThemeData(brightness: brightness).textTheme,
    ).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    // default text theme
    // final textTheme = ThemeData(
    //   colorScheme: colorScheme,
    //   brightness: brightness,
    // ).textTheme.apply(
    //   bodyColor: colorScheme.onSurface,
    //   displayColor: colorScheme.onSurface,
    // );

    const double defaultBorderRadius = 12.0; // Softer, more rounded corners

    return ThemeData(
      colorScheme: colorScheme,
      brightness: brightness,
      useMaterial3: true,
      textTheme: textTheme,
      scaffoldBackgroundColor:
          colorScheme
              .surface, // M3 uses surface, background is for behind surface
      // --- Component Theming for "小清新" style ---
      appBarTheme: AppBarTheme(
        elevation: 0.5, // Subtle elevation
        backgroundColor:
            colorScheme.surface, // Or surfaceContainer for a slight tint
        foregroundColor: colorScheme.onSurfaceVariant, // For icons and title
        iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant, size: 24),
        actionsIconTheme: IconThemeData(
          color: colorScheme.onSurfaceVariant,
          size: 24,
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600, // Slightly bolder for titles
        ),
        centerTitle: false, // Common preference
      ),

      cardTheme: CardThemeData(
        elevation: 1.0, // Very subtle shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          // side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5), width: 0.5), // Optional: subtle border
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              defaultBorderRadius / 1.5,
            ), // Slightly less round than cards
          ),
          elevation: 1, // Subtle elevation
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide(color: colorScheme.outline, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius / 1.5),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius / 1.5),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest, // A very light fill
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
        ),
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius / 1.5),
          borderSide: BorderSide.none, // No border when not focused
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius / 1.5),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
            width: 1,
          ), // Subtle border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius / 1.5),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius / 1.5),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius / 1.5),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.secondaryContainer,
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSecondaryContainer,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            defaultBorderRadius * 2,
          ), // More rounded for chips (pills)
          side: BorderSide.none,
        ),
        selectedColor: colorScheme.primaryContainer,
        secondarySelectedColor: colorScheme.primary,
        checkmarkColor: colorScheme.onPrimaryContainer,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            defaultBorderRadius * 1.5,
          ), // Larger radius for dialogs
        ),
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
            colorScheme.surfaceContainer, // Slightly different from scaffold
        elevation: 2,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant.withOpacity(0.7),
        selectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: textTheme.labelSmall,
        type: BottomNavigationBarType.fixed, // Or shifting if preferred
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius * 1.33),
        ), // M3 default is 16.0
      ),

      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius / 2),
        ),
        // tileColor: colorScheme.surfaceContainerLow, // If you want tiles to have a background
        // selectedTileColor: colorScheme.primaryContainer.withOpacity(0.5),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: textTheme.labelLarge,
        indicatorSize: TabBarIndicatorSize.label, // Or .tab
      ),

      // Add more component themes as needed:
      // sliderTheme, switchTheme, checkboxTheme, radioTheme, etc.
      // For example:
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primary.withOpacity(0.3),
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withOpacity(0.2),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary.withOpacity(0.5);
          }
          return colorScheme.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return colorScheme.outline;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent; // Or colorScheme.surfaceVariant
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        side: BorderSide(color: colorScheme.outline, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius / 3),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
      ),
    );
  }

  static ThemeData lightTheme({AppColorSeed seed = AppColorSeed.baseColor}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed.color,
      brightness: Brightness.light,
    );
    return _buildTheme(colorScheme: colorScheme, brightness: Brightness.light);
  }

  static ThemeData darkTheme({AppColorSeed seed = AppColorSeed.baseColor}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed.color,
      brightness: Brightness.dark,
    );
    return _buildTheme(colorScheme: colorScheme, brightness: Brightness.dark);
  }
}
