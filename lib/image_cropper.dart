import 'dart:html';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker_web/image_picker_web.dart';


class ImageCropper extends StatelessWidget {
  final _controller = CropController();

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: imagePicker(),
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.hasData) {
          return Crop(
              image: snapshot.data!,
              controller: _controller,
              onCropped: (image) {
                // do something with image data
              });
        } else {
          return Text("データが存在しません");
        }
      },
    );
  }
}



/*
class ImageCropper extends StatelessWidget {
  final _controller = CropController();

  Widget build(BuildContext context) {
    return Crop(
        image: imagePicker(),
        controller: _controller,
        onCropped: (image) {
          // do something with image data
        });
  }
}

 */

Future<Uint8List> imagePicker() async {
  ByteData bytes = await rootBundle.load('images/2780104_s (1).jpg');
  final imgList = Uint8List.view(bytes.buffer);
  //Uint8List pngBytes = bytes!.buffer.asUint8List();

  return imgList;
  /*
  final file = await ImagePickerWeb._pickFile('image');
  Uint8List bytesFromPicker =
  await ImagePickerWeb.getImage(outputType: ImageType.bytes
          .asUint8List();
  return bytesFromPicker;

   */
}
