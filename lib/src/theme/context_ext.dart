import 'package:flutter/material.dart';

import 'theme_extension.dart';

extension SpectrumContext on BuildContext {
  SpectrumThemeExtension get spectrum => Theme.of(this).extension<SpectrumThemeExtension>()!;
}
