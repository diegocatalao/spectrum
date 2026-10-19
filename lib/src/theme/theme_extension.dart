import 'package:flutter/material.dart';

import '../foundations/colors.dart';

// Tokens do Spectrum que não têm lugar no ColorScheme do Material.
class SpectrumThemeExtension extends ThemeExtension<SpectrumThemeExtension> {
  /// accent-background-color-hover/down: azul de hover e clique dos elementos em destaque.
  final Color accentHover;

  /// focus-indicator-color: azul do anel de foco do teclado.
  final Color focusIndicator;

  const SpectrumThemeExtension({required this.accentHover, required this.focusIndicator});

  static const light = SpectrumThemeExtension(
    accentHover: SpectrumColors.blue1000,
    focusIndicator: SpectrumColors.blue800,
  );

  static const dark = SpectrumThemeExtension(
    accentHover: SpectrumDarkColors.blue700,
    focusIndicator: SpectrumDarkColors.blue800,
  );

  @override
  SpectrumThemeExtension copyWith({Color? accentHover, Color? focusIndicator}) {
    return SpectrumThemeExtension(
      accentHover: accentHover ?? this.accentHover,
      focusIndicator: focusIndicator ?? this.focusIndicator,
    );
  }

  @override
  SpectrumThemeExtension lerp(SpectrumThemeExtension? other, double t) {
    if (other == null) return this;
    return SpectrumThemeExtension(
      accentHover: Color.lerp(accentHover, other.accentHover, t)!,
      focusIndicator: Color.lerp(focusIndicator, other.focusIndicator, t)!,
    );
  }
}
