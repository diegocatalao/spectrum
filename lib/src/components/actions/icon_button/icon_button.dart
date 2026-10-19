import 'package:flutter/material.dart';

class SpectrumIconButton extends StatelessWidget {
  final Widget icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool emphasized;

  const SpectrumIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final enabled = onPressed != null;
    final foregroundColor = emphasized ? colors.onPrimary : colors.onSurface;
    final backgroundColor = emphasized ? colors.primary : Colors.transparent;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          child: SizedBox.square(
            dimension: 32,
            child: IconTheme(
              data: IconThemeData(
                color: enabled ? foregroundColor : colors.onSurface.withValues(alpha: 0.38),
                size: 18,
              ),
              child: Center(child: icon),
            ),
          ),
        ),
      ),
    );
  }
}
