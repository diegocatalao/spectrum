import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumSkeleton)
Widget BuildSkeletonPresentation(BuildContext context) {
  return SizedBox(
    width: 320,
    child: SpectrumSkeleton(
      isLoading: context.knobs.object.segmented<bool>(
        label: 'isLoading',
        options: [true, false],
        initialOption: true,
        description: 'Whether the content is shown as gray shapes.',
      ),
      // Each bone takes the size of its content, so the loaded layout does not jump.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          SpectrumSkeletonBone(
            borderRadius: BorderRadius.circular(8),
            child: Container(height: 160, color: Theme.of(context).colorScheme.primary),
          ),
          SpectrumSkeletonBone(child: Text('Mountain lake', style: Theme.of(context).textTheme.titleLarge)),
          SpectrumSkeletonBone(child: Text('A calm lake surrounded by mountains, at sunrise.')),
          SpectrumSkeletonBone(
            child: SpectrumStatusLight(variant: SpectrumStatusVariant.positive, child: Text('Published')),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Simulated Loading', type: SpectrumSkeleton)
Widget BuildSkeletonSimulatedLoading(BuildContext context) {
  return const _SimulatedLoading();
}

/// Loads a fake list for 3 seconds, showing it as a skeleton meanwhile, with a
/// button to load it again.
class _SimulatedLoading extends StatefulWidget {
  const _SimulatedLoading();

  @override
  State<_SimulatedLoading> createState() => _SimulatedLoadingState();
}

class _SimulatedLoadingState extends State<_SimulatedLoading> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Shows the skeleton and hides it again after 3 seconds, as a slow request.
  Future<void> _load() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final files = [
      ('Brand guidelines', 'Edited 2 hours ago'),
      ('Launch video', 'Edited yesterday'),
      ('Logo', 'Edited last week'),
    ];

    return SizedBox(
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          SpectrumSkeleton(
            isLoading: _isLoading,
            child: Column(
              spacing: 12,
              children: [
                for (final (name, edited) in files)
                  Row(
                    spacing: 12,
                    children: [
                      SpectrumSkeletonBone(
                        child: SizedBox.square(
                          dimension: 40,
                          child: ColoredBox(color: Theme.of(context).colorScheme.surfaceContainerHighest),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          SpectrumSkeletonBone(child: Text(name)),
                          SpectrumSkeletonBone(child: Text(edited, style: Theme.of(context).textTheme.labelSmall)),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SpectrumButton(
            content: 'Reload',
            variant: SpectrumButtonVariant.secondary,
            isDisabled: _isLoading,
            onTap: _load,
          ),
        ],
      ),
    );
  }
}
