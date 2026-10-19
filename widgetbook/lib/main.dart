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
      directories: directories.map(_collapse).toList(),
    );
  }

  /// Recreates the generated tree with every folder and component collapsed,
  /// since the generator always creates them expanded and has no option for it.
  WidgetbookNode _collapse(WidgetbookNode node) {
    final WidgetbookNode collapsed;

    if (node is WidgetbookFolder) {
      // When the node is a folder, its children are collapsed first,
      // so the whole tree starts closed and only the top level
      // folders are shown when the Widgetbook opens.
      collapsed = WidgetbookFolder(
        name: node.name,
        children: node.children!.map(_collapse).toList(),
        isInitiallyExpanded: false,
      );
    } else if (node is WidgetbookComponent) {
      // When the node is a component, it is collapsed, but its use cases
      // are kept as they are, since a use case is a leaf and has
      // nothing to expand.
      collapsed = WidgetbookComponent(
        name: node.name,
        useCases: node.useCases,
        isInitiallyExpanded: false
      );
    } else {
      // When the node is anything else, like a use case, it is kept
      // as it is, because the generator only creates folders,
      // components and use cases.
      collapsed = node;
    }

    return collapsed;
  }
}
