import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/utils/constants.dart';

class ProvaMethodChannel extends StatefulWidget {
  const ProvaMethodChannel({super.key});

  @override
  State<ProvaMethodChannel> createState() => _ProvaMethodChannelState();
}

class _ProvaMethodChannelState extends State<ProvaMethodChannel> {
  static const platform = MethodChannel('classpic/saf_picker');

  String? _uri = 'unkwon uri';

  Future<void> _getUri() async {
    String? uri;
    try {
      final result = await platform.invokeMethod<String?>('getUri');
      uri = result;

      if (uri != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(keyFolder, uri);
      }

    } on PlatformException catch (e) {
      uri = 'failed to get uri';
    }

    setState(() {
      _uri = uri;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: _getUri,
            child: const Text('Get and display uri'),
          ),
          Text(_uri??'uri is null'),
        ],
      ),
    );
  }
}
