import 'package:flutter/material.dart';
import '../../providers/app_state.dart';

class StatusButton extends StatelessWidget {
  final String text;
  //final LoadState status;
  final bool carregat;
  final VoidCallback? onPressed;

  const StatusButton({
    Key? key,
    required this.text,
    //required this.status,
    required this.onPressed,
    required this.carregat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final Color color = _getColorFromStatus(status);
    final Color color = carregat? Colors.blue : Colors.grey;

    return ElevatedButton(
      onPressed: carregat ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
      child: Text(text),
    );
  }

  /*Color _getColorFromStatus(LoadState status) {
    switch (status) {
      case LoadState.loadedWithData:
        return Colors.blue;
      case LoadState.loading:
        return Colors.orange;
      case LoadState.error:
        return Colors.red;
      case LoadState.loadedWithoutData:
      default:
        return Colors.grey;
    }
  }*/
}
