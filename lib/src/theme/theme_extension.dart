import 'package:flutter/material.dart';

import '../foundations/colors.dart';

/// Spectrum tokens that have no place in the Material ColorScheme.
class SpectrumThemeExtension extends ThemeExtension<SpectrumThemeExtension> {
  /// accent-background-color-hover/down: blue of hovered and pressed accent elements.
  final Color accentHover;

  /// negative-background-color-hover/down: red of hovered and pressed negative elements.
  final Color negativeHover;

  /// focus-indicator-color: blue of the keyboard focus ring.
  final Color focusIndicator;

  const SpectrumThemeExtension({required this.accentHover, required this.negativeHover, required this.focusIndicator});

  static const light = SpectrumThemeExtension(
    accentHover: SpectrumColors.blue1000,
    negativeHover: SpectrumColors.red1000,
    focusIndicator: SpectrumColors.blue800,
  );

  static const dark = SpectrumThemeExtension(
    accentHover: SpectrumDarkColors.blue700,
    negativeHover: SpectrumDarkColors.red700,
    focusIndicator: SpectrumDarkColors.blue800,
  );

  /// Returns the Spectrum tokens of the theme. When the theme has no SpectrumThemeExtension,
  /// returns the light or dark defaults, following the brightness of the theme.
  static SpectrumThemeExtension of(BuildContext context) {
    final theme = Theme.of(context);
    final extension = theme.extension<SpectrumThemeExtension>();

    if (extension != null) {
      return extension;
    } else if (theme.brightness == Brightness.dark) {
      return dark;
    } else {
      return light;
    }
  }

  @override
  SpectrumThemeExtension copyWith({Color? accentHover, Color? negativeHover, Color? focusIndicator}) {
    return SpectrumThemeExtension(
      accentHover: accentHover ?? this.accentHover,
      negativeHover: negativeHover ?? this.negativeHover,
      focusIndicator: focusIndicator ?? this.focusIndicator,
    );
  }

  @override
  SpectrumThemeExtension lerp(SpectrumThemeExtension? other, double t) {
    if (other == null) return this;
    return SpectrumThemeExtension(
      accentHover: Color.lerp(accentHover, other.accentHover, t)!,
      negativeHover: Color.lerp(negativeHover, other.negativeHover, t)!,
      focusIndicator: Color.lerp(focusIndicator, other.focusIndicator, t)!,
    );
  }
}
