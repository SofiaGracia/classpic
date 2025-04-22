/*import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml_fotos/utils/carpeta.dart';

import '../models/alumne.dart';

class CameraPage extends StatelessWidget {

  final Alumne alumne;

  const CameraPage({super.key, required this.alumne});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.white,
        child: CameraAwesomeBuilder.awesome(
          onMediaCaptureEvent: (event) {
            switch ((event.status, event.isPicture, event.isVideo)) {
              case (MediaCaptureStatus.capturing, true, false):
                debugPrint('Capturing picture...');
              case (MediaCaptureStatus.success, true, false):
                event.captureRequest.when(
                  single: (single) {
                    debugPrint('Picture saved: ${single.file?.path}');
                  },
                  multiple: (multiple) {
                    multiple.fileBySensor.forEach((key, value) {
                      debugPrint('multiple image taken: $key ${value?.path}');
                    });
                  },
                );
              case (MediaCaptureStatus.failure, true, false):
                debugPrint('Failed to capture picture: ${event.exception}');
              case (MediaCaptureStatus.capturing, false, true):
                debugPrint('Capturing video...');
              case (MediaCaptureStatus.success, false, true):
                event.captureRequest.when(
                  single: (single) {
                    debugPrint('Video saved: ${single.file?.path}');
                  },
                  multiple: (multiple) {
                    multiple.fileBySensor.forEach((key, value) {
                      debugPrint('multiple video taken: $key ${value?.path}');
                    });
                  },
                );
              case (MediaCaptureStatus.failure, false, true):
                debugPrint('Failed to capture video: ${event.exception}');
              default:
                debugPrint('Unknown event: $event');
            }
          },
          saveConfig: SaveConfig.photoAndVideo(
            initialCaptureMode: CaptureMode.photo,
            photoPathBuilder: (sensors) async {
              //final Directory extDir = await getTemporaryDirectory();
              String? pathDir = GestorCarpetes.obtenirPathCarpeta(alumne.grup);
              final Directory extDir = Directory(pathDir!);
              /*final testDir = await Directory(
                '${extDir.path}/camerawesome',
              ).create(recursive: true);*/
              if (sensors.length == 1) {
                final String filePath =
                    '${extDir.path}/${alumne.nom}_${alumne.nia}.jpg';
                return SingleCaptureRequest(filePath, sensors.first);
              }
              // Separate pictures taken with front and back camera
              return MultipleCaptureRequest(
                {
                  for (final sensor in sensors)
                    sensor:
                    '${extDir.path}/${sensor.position == SensorPosition.front ? 'front_' : "back_"}${DateTime.now().millisecondsSinceEpoch}.jpg',
                },
              );
            },
            videoOptions: VideoOptions(
              enableAudio: true,
              ios: CupertinoVideoOptions(
                fps: 10,
              ),
              android: AndroidVideoOptions(
                bitrate: 6000000,
                fallbackStrategy: QualityFallbackStrategy.lower,
              ),
            ),
            exifPreferences: ExifPreferences(saveGPSLocation: true),
          ),
          sensorConfig: SensorConfig.single(
            sensor: Sensor.position(SensorPosition.back),
            flashMode: FlashMode.auto,
            aspectRatio: CameraAspectRatios.ratio_4_3,
            zoom: 0.0,
          ),
          enablePhysicalButton: true,
          // filter: AwesomeFilter.AddictiveRed,
          previewAlignment: Alignment.center,
          previewFit: CameraPreviewFit.contain,
          onMediaTap: (mediaCapture) {
            mediaCapture.captureRequest.when(
              single: (single) {
                debugPrint('single: ${single.file?.path}');
                //single.file?.open();
                debugPrint('Tipus de objecte: ${single.toString()}');
              },
              multiple: (multiple) {
                multiple.fileBySensor.forEach((key, value) {
                  debugPrint('multiple file taken: $key ${value?.path}');
                  //value?.open();
                });
              },
            );
          },
          availableFilters: awesomePresetFiltersList,
        ),
      ),
    );
  }
}*/