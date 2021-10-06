import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CanvasMaker extends StatelessWidget {
  const CanvasMaker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      child: FutureBuilder(
        future: fCanvasMaker(deviceWidth, deviceHeight),
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.hasData) {
            return Container(
                //width: double.infinity,
                child: SizedBox(
                    width: deviceWidth*0.5,
                    //height: deviceHeight*0.2,
                    child: Image.memory(snapshot.data!)));
          } else {
            return Text("データが存在しません");
          }
        },
      ),
    );
  }
}

Future<Uint8List> fCanvasMaker(deviceWidth, deviceHeight) async {
  //PictureRecorderでCanvasへの命令を記録する
  final recorder = ui.PictureRecorder();
  //Canvasをつくる
  final canvas = Canvas(recorder);
  //final paint = Paint()..isAntiAlias = true;
  //double? deviceHeight;

  //Textに関するまとまりをつくる
  var span = TextSpan(
    style: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,

    ),
    text: '好きなテキストを指定してくだされ😇',
  );

  //Canvasにspanを描出
  final textPainter = TextPainter(
    text: span,
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  textPainter.paint(canvas, Offset(0, 0));

  //レコーディング終了
  final picture = recorder.endRecording();
  //画像のimage型に変更して、画像サイズもいじる。画像のサイズはCanvasからどこを切り抜くかを決定している。
  final image = await picture.toImage(420, 40);
  //pngのbyte dataに変換
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  //Uint8List型に変換
  final Uint8List pngBytes = byteData!.buffer.asUint8List();
  //print(pngBytes);
  return pngBytes;
}
