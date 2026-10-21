import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumSubmenuTrigger)
Widget BuildSubmenuTriggerPresentation(BuildContext context) {
  return SpectrumActionMenu(
    icon: SpectrumIcon(SpectrumIcons.more),
    label: 'More actions',
    children: [
      SpectrumMenuItem(icon: SpectrumIcon(SpectrumIcons.edit), child: Text('Edit')),
      SpectrumSubmenuTrigger(
        menu: [
          SpectrumMenuItem(onTap: () => log('Share by email.'), child: Text('Email')),
          SpectrumMenuItem(onTap: () => log('Share by link.'), child: Text('Copy link')),
          SpectrumSubmenuTrigger(
            menu: [
              SpectrumMenuItem(child: Text('Messages')),
              SpectrumMenuItem(child: Text('Chat')),
            ],
            child: SpectrumMenuItem(child: Text('More')),
          ),
        ],
        child: SpectrumMenuItem(icon: SpectrumIcon(SpectrumIcons.share), child: Text('Share')),
      ),
      SpectrumMenuItem(icon: SpectrumIcon(SpectrumIcons.delete), child: Text('Delete')),
    ],
  );
}
