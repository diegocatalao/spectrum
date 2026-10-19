# spectrum

A Flutter implementation of [Adobe Spectrum](https://spectrum.adobe.com), the design system behind
Adobe's products.

> **Status:** early development. Many components are still placeholders and the API may change
> between versions without notice.

This is an independent project and is not affiliated with or endorsed by Adobe.

## Features

- Light and dark themes built on Material 3, with Spectrum colors, typography and spacing tokens.
- Components that follow the Spectrum 2 guidelines, using the medium (M) desktop size.
- Keyboard focus rings and screen reader semantics on interactive components.
- A [Widgetbook](https://widgetbook.io) catalog to browse and test every component.

## Installation

The package is not published on pub.dev yet. Add it as a Git dependency:

```yaml
dependencies:
  spectrum:
    git:
      url: https://github.com/diegocatalao/spectrum.git
```

## Usage

Apply one of the Spectrum themes and use the components as regular widgets:

```dart
import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

void main() {
  runApp(
    MaterialApp(
      theme: SpectrumTheme.light(),
      darkTheme: SpectrumTheme.dark(),
      home: Scaffold(
        body: Center(
          child: SpectrumActionButton(
            icon: SpectrumIcon(SpectrumIcons.edit),
            child: const Text('Edit'),
            onTap: () {},
          ),
        ),
      ),
    ),
  );
}
```

## Components

| Category      | Implemented                                                        |
| ------------- | ------------------------------------------------------------------ |
| Accordion     | Accordion, Accordion Item                                          |
| Actions       | Action Bar, Action Button, Action Group, Action Menu, Menu         |
| Buttons       | Close Button                                                       |
| Containers    | Divider                                                            |

Other components exist as placeholders and are listed in the Widgetbook catalog.

## Development

The project uses [FVM](https://fvm.app) to pin the Flutter version.

```sh
flutter pub get
flutter analyze
flutter test
dart format -l 120 lib test
```

To run the component catalog:

```sh
cd widgetbook
flutter pub get
dart run build_runner watch -d
flutter run -d chrome
```

## License

Licensed under the [Apache License 2.0](LICENSE).

Adobe and Spectrum are trademarks of Adobe Inc.
