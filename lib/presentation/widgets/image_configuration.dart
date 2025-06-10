import 'package:flutter/cupertino.dart';

import 'image_resolution.dart';

class ImageConfigurationWidget extends StatelessWidget {
  const ImageConfigurationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('resolucio de la imatge'),
          ImageResolutionWidget()
        ],
      ),
    );
  }
}
