import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Response times in milliseconds, close to a normal distribution around 200.
const _times = <double>[
  120.0,
  135,
  150,
  152,
  160,
  168,
  170,
  175,
  178,
  180,
  182,
  185,
  188,
  190,
  192,
  195,
  196,
  198,
  200,
  200,
  202,
  204,
  205,
  207,
  210,
  212,
  215,
  218,
  220,
  224,
  228,
  232,
  240,
  248,
  255,
  262,
  275,
  290,
  310,
  340,
];

@widgetbook.UseCase(name: 'Presentation', type: SpectrumHistogram)
Widget BuildHistogramPresentation(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: SpectrumHistogram(
      values: _times,
      binCount: context.knobs.int.slider(
        label: 'binCount',
        initialValue: 10,
        min: 2,
        max: 30,
        description: 'Number of bins between the smallest and the largest value.',
      ),
      formatX: (value) => '${value.round()}ms',
    ),
  );
}
