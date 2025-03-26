import 'package:flutter/material.dart';

class MyCircularProgressIndicator extends StatelessWidget  {
  const MyCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
          width:200,
          height: 200,
          child: CircularProgressIndicator()),
    );
  }
}
