import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'main.directories.g.dart';
void main() {
  runApp(const SpectrumWidgetBook());
}

@widgetbook.App()
class SpectrumWidgetBook extends StatelessWidget {
  const SpectrumWidgetBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Dark', data: SpectrumTheme.dark()),
            WidgetbookTheme(name: 'Light', data: SpectrumTheme.light()),
          ],
        ),
        // The padding keeps 16px between the canvas edge and the components,
        // so the focus ring, drawn 4px outside of them, is never cut. It comes
        // after the theme addon, so the space is painted with the theme background.
        BuilderAddon(
          name: 'Padding',
          builder: (context, child) {
            return Padding(padding: const EdgeInsets.all(24), child: child);
          },
        ),
        // Centers the components by default, and lets the panel move them
        // to any corner, so small components like the Badge are not lost
        // in the top left corner of the canvas.
        AlignmentAddon(),
      ],
      directories: directories,
    );
  }
}
