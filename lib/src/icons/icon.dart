import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spectrum/spectrum.dart';

/// Displays a Spectrum SVG icon.
class SpectrumIcon extends StatelessWidget {
  const SpectrumIcon(
    this.asset, {
    super.key,
    this.size = 12,
    this.color,
    this.semanticsLabel,
    this.fit = BoxFit.contain,
  });

  final SpectrumIcons asset;
  final double size;
  final Color? color;
  final String? semanticsLabel;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final color = this.color ??
                  IconTheme.of(context).color ??
                  Theme.of(context).colorScheme.onSurface;

    return SvgPicture.asset(
      asset.name,
      package: 'spectrum',
      width: size,
      height: size,
      fit: fit,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      semanticsLabel: semanticsLabel,
    );
  }
}
