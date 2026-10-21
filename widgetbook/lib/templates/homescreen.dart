import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Home screen of an app built with the Spectrum components.
class HomeScreenTemplate extends StatelessWidget {
  const HomeScreenTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Hello, Spectrum')),
    );
  }
}

@widgetbook.UseCase(name: 'Presentation', type: HomeScreenTemplate, path: '[Templates]')
Widget buildHomeScreenPresentation(BuildContext context) {
  // The device frame is applied only here, instead of as an addon,
  // so the components keep their plain canvas.
  return DeviceFrame(device: Devices.ios.iPhone13, screen: const HomeScreenTemplate());
}
