import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class CanvasMaker2 extends StatelessWidget {
  const CanvasMaker2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      child: FutureBuilder(
        future: pngMaker(),
        builder:
            (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.hasData) {
            return Container(
                //width: double.infinity,
                child: Image.memory(snapshot.data!));
          } else {
            return Text("データが存在しません");
          }
        },
      ),
    );
  }
}



Future<ui.Image> fCanvasMaker2() async {
  //PictureRecorderでCanvasへの命令を記録する
  final recoder = ui.PictureRecorder();
  final canvas = Canvas(recoder);
  final paint = Paint()..isAntiAlias = true;

  final rawData = await rootBundle.load("images/2780104_s (1).jpg");
  final imgList = Uint8List.view(rawData.buffer);

  final Completer<ui.Image> completer = new Completer();
  ui.decodeImageFromList(imgList, (img) async{
    //画像から切り出す部分指定
    final src = Rect.fromLTWH(0, 0, 300, 300);
    //画像の位置と縮尺を指定
    const dst = Rect.fromLTWH(0, 0, 300, 300);
    canvas.drawImageRect(img, src, dst, paint);

    const span = TextSpan(
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      text: '好きなテキストを指定してくだされ😇',
    );
    final textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(0, 120));

    final picture = recoder.endRecording();
    final image = await picture.toImage(400, 400);
    return completer.complete(image);
  });
  return completer.future;
}

Future<Uint8List> pngMaker()async{
  //fCanvas2Makerをもちいて、編集されたimage型のデータを取得
  ui.Image image = await fCanvasMaker2();
  //pngのbyte dataに変換
  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //Uint8List型に変換
  final Uint8List pngBytes = byteData!.buffer.asUint8List();
  //print(pngBytes);
  return pngBytes;

}

/*
//pngのbyte dataに変換
final ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);
//Uint8List型に変換
final Uint8List pngBytes = byteData!.buffer.asUint8List();
//print(pngBytes);

 */