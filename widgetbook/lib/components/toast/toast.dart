import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumToast)
Widget BuildToastPresentation(BuildContext context) {
  final hasAction = context.knobs.object.segmented<bool>(
    label: 'action',
    options: [true, false],
    initialOption: false,
    description: 'Whether the toasts have an action button, staying until closed.',
  );
  final placement = context.knobs.object.dropdown<SpectrumToastPlacement>(
    label: 'placement',
    options: SpectrumToastPlacement.values,
    initialOption: SpectrumToastPlacement.bottom,
    labelBuilder: (SpectrumToastPlacement value) => value.name,
    description: 'Where the toasts are shown.',
  );
  final actionLabel = hasAction ? 'Undo' : null;
  void onAction() => log('BuildToastPresentation action was tapped.');

  // The container shows the toasts over this box, as it would over a whole app.
  return SizedBox(
    width: 640,
    height: 360,
    child: SpectrumToastContainer(
      placement: placement,
      child: Center(
        child: SpectrumButtonGroup(
          children: [
            SpectrumButton(
              content: 'Neutral',
              variant: SpectrumButtonVariant.secondary,
              onTap: () => SpectrumToastQueue.neutral(
                'Toast available',
                actionLabel: actionLabel,
                onAction: onAction,
                timeout: const Duration(seconds: 5),
              ),
            ),
            SpectrumButton(
              content: 'Positive',
              onTap: () => SpectrumToastQueue.positive(
                'Toast is done!',
                actionLabel: actionLabel,
                onAction: onAction,
                timeout: const Duration(seconds: 5),
              ),
            ),
            SpectrumButton(
              content: 'Negative',
              variant: SpectrumButtonVariant.negative,
              onTap: () => SpectrumToastQueue.negative(
                'Toast is burned!',
                actionLabel: actionLabel,
                onAction: onAction,
                timeout: const Duration(seconds: 5),
              ),
            ),
            SpectrumButton(
              content: 'Info',
              variant: SpectrumButtonVariant.accent,
              onTap: () => SpectrumToastQueue.info(
                'Toasting…',
                actionLabel: actionLabel,
                onAction: onAction,
                timeout: const Duration(seconds: 5),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
