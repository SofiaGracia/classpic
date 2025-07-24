import 'package:flutter/cupertino.dart';
import 'package:xml_fotos/shared/themes/basic_theme.dart';

import 'image_resolution.dart';

class ImageConfigurationWidget extends StatelessWidget {
  const ImageConfigurationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('resolucio de la imatge',
          style: getTheme(context).textTheme.bodyMedium,),
          ImageResolutionWidget()
        ],
      ),
    );
  }
}
