import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Coach Mark: a pulsing indicator on a part of the app that opens a popover
/// with a tip, used to onboard users step by step.
class SpectrumCoachMark extends StatelessWidget {
  /// The part of the app the coach mark points to.
  final Widget child;

  /// Title of the tip.
  final Text heading;

  /// Text of the tip.
  final Widget content;

  /// Step of the tour, like "2 of 4".
  final String? step;

  /// Text of the primary button, like "Next".
  final String primaryActionLabel;

  /// Text of the secondary button, like "Skip tour".
  final String? secondaryActionLabel;

  /// Called when the primary button is tapped, before the popover closes.
  final VoidCallback? onPrimaryAction;

  /// Called when the secondary button is tapped, before the popover closes.
  final VoidCallback? onSecondaryAction;

  /// Placement of the popover around the indicator.
  final SpectrumPopoverPlacement placement;

  const SpectrumCoachMark({
    super.key,
    required this.child,
    required this.heading,
    required this.content,
    this.step,
    this.primaryActionLabel = 'Next',
    this.secondaryActionLabel,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.placement = SpectrumPopoverPlacement.right,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        child,
        SpectrumPopover(
          placement: placement,
          padding: const EdgeInsets.all(16),
          trigger: (context, onToggle) => Semantics(
            button: true,
            label: heading.data,
            child: GestureDetector(onTap: onToggle, child: const _Pulse()),
          ),
          // Spectrum coach mark popover: 280px, the heading with the step, the text and
          // the buttons at the end.
          child: Builder(
            builder: (context) {
              final close = SpectrumPopover.closeOf(context);

              return SizedBox(
                width: 280,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 12,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DefaultTextStyle(
                            style: (textTheme.titleMedium ?? const TextStyle()).copyWith(color: colors.inverseSurface),
                            child: heading,
                          ),
                        ),
                        Visibility(
                          visible: step != null,
                          child: Text(
                            step ?? '',
                            style: (textTheme.labelSmall ?? const TextStyle()).copyWith(color: colors.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                    DefaultTextStyle(
                      style: (textTheme.bodySmall ?? const TextStyle()).copyWith(color: colors.onSurface),
                      child: content,
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: SpectrumButtonGroup(
                        children: [
                          ?_secondary(close),
                          SpectrumButton(
                            content: primaryActionLabel,
                            variant: SpectrumButtonVariant.accent,
                            onTap: () {
                              onPrimaryAction?.call();
                              close?.call();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  SpectrumButton? _secondary(VoidCallback? close) {
    if (secondaryActionLabel == null) {
      return null;
    }

    return SpectrumButton(
      content: secondaryActionLabel!,
      variant: SpectrumButtonVariant.secondary,
      isOutline: true,
      onTap: () {
        onSecondaryAction?.call();
        close?.call();
      },
    );
  }
}

/// The pulsing indicator of the coach mark: a 16px accent dot with a ring that grows
/// and fades, repeating.
class _Pulse extends StatefulWidget {
  const _Pulse();

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isStill = MediaQuery.of(context).disableAnimations;

    return SizedBox.square(
      dimension: 32,
      child: AnimatedBuilder(
        animation: _controller ?? kAlwaysDismissedAnimation,
        builder: (context, child) {
          final value = isStill ? 0.0 : (_controller?.value ?? 0);

          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 16 + 16 * value,
                height: 16 + 16 * value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary.withValues(alpha: 0.4 * (1 - value)),
                ),
              ),
              child!,
            ],
          );
        },
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.primary,
            border: Border.all(color: SpectrumColors.white, width: 2),
          ),
        ),
      ),
    );
  }
}
