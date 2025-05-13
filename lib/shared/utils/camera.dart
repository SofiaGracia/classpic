/*import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class CameraPage extends StatelessWidget {
  final String pathPhoto;
  final String pathDir;

  const CameraPage(
      {super.key,
      required this.pathPhoto,
      required this.pathDir});

  //Cuidao en el que retornem: No sé si vull un File o un XFijle
  Future<XFile?> compressToUnder100KB(File file, String targetPath) async {
    int quality = 80;
    File? result;

    while (quality > 10) {
      final compressed = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: 640,
        minHeight: 480,
      );

      if (compressed == null) return null;

      final size = await compressed.length();
      if (size <= 102400) {
        return compressed;
      } else {
        quality -= 10;
      }
    }

    return null; // no s'ha pogut aconseguir sota 100KB
  }

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
              case (MediaCaptureStatus.success, true, false)://Ací
                event.captureRequest.when(
                  single: (single) async {
                    //Per ací és la última parada
                    debugPrint('Picture saved: ${single.file?.path}');

                    final original = single.file!;
                    //ACÍ PODRIEM COMPRIMIR LA FOTO
                    File file = File(original.path);
                    final compressed = await compressToUnder100KB(file, single.file!.path);

                    //ACÍ RETORNEM LA FOTO
                    if (Navigator.of(context).canPop()) {

                      File file = File(compressed!.path);
                      Navigator.pop(context, file);
                    }
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
              final Directory extDir = Directory(pathDir);
              if (sensors.length == 1) {
                final String filePath = pathPhoto;
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
            //Ací aniria les videoOptions
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
