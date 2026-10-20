import 'package:flutter/material.dart';

import 'color_scheme.dart';
import 'theme_extension.dart';

abstract final class SpectrumTheme {
  static ThemeData light() => _build(SpectrumColorScheme.light(), SpectrumThemeExtension.light);

  static ThemeData dark() => _build(SpectrumColorScheme.dark(), SpectrumThemeExtension.dark);

  static ThemeData _build(ColorScheme colorScheme, SpectrumThemeExtension spectrum) {
    final theme = ThemeData(
      useMaterial3: true,
      package: 'spectrum',
      fontFamily: 'OpenSans',
      colorScheme: colorScheme,
      textTheme: _textTheme,
      extensions: [spectrum],
    );

    return theme.copyWith(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      listTileTheme: ListTileThemeData(
        titleTextStyle: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.inverseSurface,
        ),
      ),
      scaffoldBackgroundColor: colorScheme.surfaceContainerLow,
      hoverColor: colorScheme.inverseSurface.withValues(alpha: 0.1),
      highlightColor: colorScheme.inverseSurface.withValues(alpha: 0.00),
    );
  }

  // Spectrum 2 desktop type scale (size M): Heading → display/headline/title, Body → body, Detail → label.
  // Weights follow the Spectrum 2 tokens: heading extra-bold, body regular, detail medium.
  static const _heading = TextStyle(fontWeight: FontWeight.w800, height: 1.3, letterSpacing: 0);
  static const _body = TextStyle(fontWeight: FontWeight.w400, height: 1.5, letterSpacing: 0);
  static const _detail = TextStyle(fontWeight: FontWeight.w500, height: 1.3);

  // Open Sans has a taller x-height than Adobe Clean, so the scale is reduced to keep the same visual size.
  static const _fontScale = 0.88;

  static TextStyle _sized(TextStyle style, double size, {double letterSpacing = 0}) =>
      style.copyWith(fontSize: size * _fontScale, letterSpacing: letterSpacing * size * _fontScale);

  static final _textTheme = TextTheme(
    displayLarge: _sized(_heading, 58), // Heading XXXL
    displayMedium: _sized(_heading, 45), // Heading XXL
    displaySmall: _sized(_heading, 36), // Heading XL
    headlineLarge: _sized(_heading, 28), // Heading L
    headlineMedium: _sized(_heading, 22), // Heading M
    headlineSmall: _sized(_heading, 20), // Heading S
    titleLarge: _sized(_heading, 18), // Heading XS
    titleMedium: _sized(_heading, 14), // Heading XXS
    titleSmall: _sized(_heading, 12),
    bodyLarge: _sized(_body, 18), // Body L
    bodyMedium: _sized(_body, 16), // Body M
    bodySmall: _sized(_body, 14), // Body S
    labelLarge: _sized(_detail, 16, letterSpacing: 0.06), // Detail L
    labelMedium: _sized(_detail, 14, letterSpacing: 0.06), // Detail M
    labelSmall: _sized(_detail, 12, letterSpacing: 0.06), // Detail S
  );
}
