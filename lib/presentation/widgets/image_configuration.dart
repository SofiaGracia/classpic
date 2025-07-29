import 'package:flutter/cupertino.dart';
import 'package:xml_fotos/shared/themes/basic_theme.dart';

import 'image_resolution.dart';

class ImageConfigurationWidget extends StatelessWidget {
  const ImageConfigurationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Resolucio de la imatge',
          style: getTheme(context).textTheme.bodyMedium,
        ),
        ImageResolutionWidget()
      ],
    );
  }
}
