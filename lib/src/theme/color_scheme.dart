import 'package:flutter/material.dart';

import '../foundations/colors.dart';

/// Maps the Spectrum 2 semantic tokens to the Material ColorScheme:
/// primary → accent, secondary → neutral, error → negative, *Container → subtle background,
/// surface → background-base, onSurface → body/neutral content, outline → border, outlineVariant → divider.
abstract final class SpectrumColorScheme {
  static ColorScheme light() => const ColorScheme.light(
    primary: SpectrumColors.blue900,
    onPrimary: SpectrumColors.white,
    primaryContainer: SpectrumColors.blue200,
    onPrimaryContainer: SpectrumColors.gray900,
    secondary: SpectrumColors.gray800,
    onSecondary: SpectrumColors.gray25,
    secondaryContainer: SpectrumColors.gray100,
    onSecondaryContainer: SpectrumColors.gray900,
    error: SpectrumColors.red900,
    onError: SpectrumColors.white,
    errorContainer: SpectrumColors.red200,
    onErrorContainer: SpectrumColors.gray900,
    surface: SpectrumColors.gray25,
    onSurface: SpectrumColors.gray800,
    onSurfaceVariant: SpectrumColors.gray700,
    outline: SpectrumColors.gray400,
    outlineVariant: SpectrumColors.gray200,
    surfaceContainerLowest: SpectrumColors.gray25,
    surfaceContainerLow: SpectrumColors.gray50,
    surfaceContainer: SpectrumColors.gray75,
    surfaceContainerHigh: SpectrumColors.gray100,
    surfaceContainerHighest: SpectrumColors.gray200,
    inverseSurface: SpectrumColors.gray900,
    onInverseSurface: SpectrumColors.gray50,
    inversePrimary: SpectrumDarkColors.blue800,
    shadow: Color(0x1F000000), // drop-shadow-color: preto 12%
    scrim: SpectrumColors.black,
  );

  static ColorScheme dark() => const ColorScheme.dark(
    primary: SpectrumDarkColors.blue800,
    onPrimary: SpectrumDarkColors.white,
    primaryContainer: SpectrumDarkColors.blue300,
    onPrimaryContainer: SpectrumDarkColors.gray900,
    secondary: SpectrumDarkColors.gray800,
    onSecondary: SpectrumDarkColors.gray25,
    secondaryContainer: SpectrumDarkColors.gray300,
    onSecondaryContainer: SpectrumDarkColors.gray900,
    error: SpectrumDarkColors.red800,
    onError: SpectrumDarkColors.white,
    errorContainer: SpectrumDarkColors.red300,
    onErrorContainer: SpectrumDarkColors.gray900,
    surface: SpectrumDarkColors.gray25,
    onSurface: SpectrumDarkColors.gray800,
    onSurfaceVariant: SpectrumDarkColors.gray700,
    outline: SpectrumDarkColors.gray400,
    outlineVariant: SpectrumDarkColors.gray200,
    surfaceContainerLowest: SpectrumDarkColors.gray25,
    surfaceContainerLow: SpectrumDarkColors.gray50,
    surfaceContainer: SpectrumDarkColors.gray75,
    surfaceContainerHigh: SpectrumDarkColors.gray100,
    surfaceContainerHighest: SpectrumDarkColors.gray200,
    inverseSurface: SpectrumDarkColors.gray900,
    onInverseSurface: SpectrumDarkColors.gray50,
    inversePrimary: SpectrumColors.blue900,
    shadow: Color(0x5C000000), // drop-shadow-color: preto 36%
    scrim: SpectrumDarkColors.black,
  );
}
