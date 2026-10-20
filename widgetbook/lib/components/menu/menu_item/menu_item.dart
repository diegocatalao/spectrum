import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumMenuItem)
Widget BuildMenuItemPresentation(BuildContext context) {
  // Empty texts mean that the item is built without that part.
  final description = context.knobs.string(
    label: 'description',
    initialValue: '',
    description: 'The text below the label. Empty hides it.',
  );
  final value = context.knobs.string(
    label: 'value',
    initialValue: '',
    description: 'The text on the right of the label. Empty hides it.',
  );
  final keyboard = context.knobs.string(
    label: 'keyboard',
    initialValue: '',
    description: 'The keyboard shortcut, like ⌘C. Empty hides it.',
  );
  final href = context.knobs.string(
    label: 'href',
    initialValue: '',
    description: 'The address opened on tap, with the link out arrow. Empty hides it.',
  );
  final hasImage = context.knobs.object.segmented<bool>(
    label: 'image',
    options: [true, false],
    initialOption: false,
    description: 'Whether the item shows a 40px image in the place of the icon.',
  );

  return SizedBox(
    width: 240,
    child: SpectrumMenuItem(
      icon: SpectrumIcon(SpectrumIcons.edit),
      image: hasImage ? Image.memory(_whiteImage) : null,
      description: description.isEmpty ? null : Text(description),
      value: value.isEmpty ? null : Text(value),
      keyboard: keyboard.isEmpty ? null : Text(keyboard),
      href: href.isEmpty ? null : Uri.tryParse(href),
      isSelected: context.knobs.object.segmented<bool>(
        label: 'isSelected',
        options: [true, false],
        initialOption: false,
        description: 'Whether the item shows the selection mark.',
      ),
      isDisabled: context.knobs.object.segmented<bool>(
        label: 'isDisabled',
        options: [true, false],
        initialOption: false,
        description: 'Whether the item is disabled.',
      ),
      onTap: () => log('BuildMenuItemPresentation item was tapped.'),
      child: Text(context.knobs.string(label: 'content', initialValue: 'Edit', description: 'The text of the item.')),
    ),
  );
}

@widgetbook.UseCase(name: 'With Description Text', type: SpectrumMenuItem)
Widget BuildMenuItemWithText(BuildContext context) {
  return ConstrainedBox(
    constraints: BoxConstraints(minWidth: 128, maxWidth: 256),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpectrumMenuItem(
          icon: SpectrumIcon(SpectrumIcons.copy),
          onTap: () => log("The Publish and Export button was pressed"),
          keyboard: Text("⌘D"),
          child: Text("Publish and export"),
        ),
        SpectrumMenuItem(
          icon: SpectrumIcon(SpectrumIcons.image),
          onTap: () => log("The Quick Export button was pressed"),
          description: Text("Share a low-res snapshot."),
          keyboard: Text("⌘C"),
          child: Text("Quick Export"),
        ),
        SpectrumMenuItem(
          icon: SpectrumIcon(SpectrumIcons.copy),
          onTap: () => log("The Open a copy button was pressed"),
          description: Text("Ilustrator for iPad or desktop."),
          value: SpectrumIcon(SpectrumIcons.info),
          child: Text("Open a copy"),
        ),
        SpectrumMenuItem(
          icon: SpectrumIcon(SpectrumIcons.link),
          onTap: () => log("We are going to Google."),
          description: Text("It sends you into the ten dimensions of Google."),
          href: Uri.parse("https://www.google.com/"),
          child: Text("Sent me to Google"),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Keyboard Shortcut', type: SpectrumMenuItem)
Widget BuildMenuItemKeyboardShortcut(BuildContext context) {
  return ConstrainedBox(
    constraints: BoxConstraints(minWidth: 128, maxWidth: 256),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpectrumMenuItem(
          icon: SpectrumIcon(SpectrumIcons.copy),
          keyboard: Text('⌘C'),
          description: Text('Copy the selected text'),
          onTap: () => log('The Copy item was tapped.'),
          child: Text('Copy'),
        ),
        SpectrumMenuItem(
          icon: SpectrumIcon(SpectrumIcons.cut),
          keyboard: Text('⌘X'),
          description: Text('Cut the selected text'),
          onTap: () => log('The Cut item was tapped.'),
          child: Text('Cut'),
        ),
        SpectrumMenuItem(
          icon: SpectrumIcon(SpectrumIcons.paste),
          keyboard: Text('⌘V'),
          description: Text('Paste the copied text'),
          isDisabled: true,
          onTap: () => log('The Paste item was tapped.'),
          child: Text('Paste'),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Value', type: SpectrumMenuItem)
Widget BuildMenuItemValue(BuildContext context) {
  return ConstrainedBox(
    constraints: BoxConstraints(minWidth: 128, maxWidth: 256),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpectrumMenuItem(value: Text('100%'), onTap: () => log('The Zoom item was tapped.'), child: Text('Zoom')),
        SpectrumMenuItem(
          value: SpectrumIcon(SpectrumIcons.info),
          onTap: () => log('The Properties item was tapped.'),
          child: Text('Properties'),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Link', type: SpectrumMenuItem)
Widget BuildMenuItemLink(BuildContext context) {
  return ConstrainedBox(
    constraints: BoxConstraints(minWidth: 128, maxWidth: 256),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpectrumMenuItem(href: Uri.parse('https://react-spectrum.adobe.com'), child: Text('React Spectrum')),
        SpectrumMenuItem(
          href: Uri.parse('https://spectrum.adobe.com'),
          description: Text('Adobe design system'),
          child: Text('Spectrum'),
        ),
      ],
    ),
  );
}

/// A 1x1 white PNG, so the image use case works offline.
final _whiteImage = Uint8List.fromList([
  137,
  80,
  78,
  71,
  13,
  10,
  26,
  10,
  0,
  0,
  0,
  13,
  73,
  72,
  68,
  82,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  1,
  8,
  2,
  0,
  0,
  0,
  144,
  119,
  83,
  222,
  0,
  0,
  0,
  12,
  73,
  68,
  65,
  84,
  120,
  156,
  99,
  248,
  255,
  255,
  63,
  0,
  5,
  254,
  2,
  254,
  13,
  239,
  70,
  184,
  0,
  0,
  0,
  0,
  73,
  69,
  78,
  68,
  174,
  66,
  96,
  130,
]);

@widgetbook.UseCase(name: 'Image', type: SpectrumMenuItem)
Widget BuildMenuItemImage(BuildContext context) {
  return ConstrainedBox(
    constraints: BoxConstraints(minWidth: 128, maxWidth: 256),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpectrumMenuItem(
          image: Image.memory(_whiteImage),
          description: Text('Edited 2 hours ago'),
          onTap: () => log('The Forest item was tapped.'),
          child: Text('Forest'),
        ),
        SpectrumMenuItem(
          image: Image.memory(_whiteImage),
          description: Text('Edited yesterday'),
          onTap: () => log('The Mountains item was tapped.'),
          child: Text('Mountains'),
        ),
        SpectrumMenuItem(
          image: Image.memory(_whiteImage),
          onTap: () => log('The Coffee item was tapped.'),
          child: Text('Coffee'),
        ),
      ],
    ),
  );
}
