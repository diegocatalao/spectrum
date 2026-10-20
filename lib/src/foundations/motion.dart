import 'package:flutter/animation.dart';

/// Spectrum 2 motion tokens: the transition durations and easing curves of
/// the React Spectrum S2 theme, shared by every animation of the package.
abstract final class SpectrumMotion {
  /// Default transition duration, the same as duration100.
  static const duration = duration100;

  static const duration0 = Duration.zero;
  static const duration100 = Duration(milliseconds: 130);
  static const duration200 = Duration(milliseconds: 160);
  static const duration300 = Duration(milliseconds: 190);
  static const duration400 = Duration(milliseconds: 220);
  static const duration500 = Duration(milliseconds: 250);
  static const duration600 = Duration(milliseconds: 300);
  static const duration700 = Duration(milliseconds: 350);
  static const duration800 = Duration(milliseconds: 400);
  static const duration900 = Duration(milliseconds: 450);
  static const duration1000 = Duration(milliseconds: 500);
  static const duration2000 = Duration(milliseconds: 1000);
  static const duration4000 = Duration(milliseconds: 2000);

  /// Default easing, the same as easeInOut.
  static const curve = easeInOut;

  /// Starts and ends slowly, for elements that change in place.
  static const easeInOut = Cubic(0.45, 0, 0.4, 1);

  /// Starts slowly, for elements leaving the screen.
  static const easeIn = Cubic(0.5, 0, 1, 1);

  /// Ends slowly, for elements entering the screen.
  static const easeOut = Cubic(0, 0, 0.4, 1);

  /// Constant speed.
  static const linear = Curves.linear;
}
