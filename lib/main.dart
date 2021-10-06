import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:practice3/canvas_maker.dart';
import 'package:practice3/image_pick.dart';
import 'package:url_strategy/url_strategy.dart';

import 'canvas_maker2.dart';
import 'image_cropper.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: MyHomePage(title: 'Flutter Demo Home Page!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String inputedValue = "";
  Uint8List? bytes;

  void imagePick2() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    //print(result);

    Uint8List fileBytes = result!.files.first.bytes!;
    //Uint8List fileBytes2 = result!.files.single.bytes!;
    //print(fileBytes);
    //String fileName = result.files.first.name;
    setState(() {
      bytes = fileBytes;
    });
    // Upload file
    //await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Container(
                width: 300,
                child: Stack(
                  //stackもcolumnと同じで位置の情報をもつ
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: Image.asset("images/syamiko2.jpeg"),
                    ),
                    Text(
                      "${this.inputedValue}",
                      style: TextStyle(
                          fontFamily: 'KouzanMouhituFontOTF.otf',
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      //overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "テキストボックス",
                hintText: "まぁ何か入力してみてよ！",
              ),

              // 最大入力可能文字数
              maxLength: 192,

              // 変更を即時反映する。
              onChanged: (text) {
                if (text.length > 0) {
                  // 入力値があるなら、それを反映する。
                  setState(() {
                    this.inputedValue = text;
                  });
                } else {
                  setState(() {
                    this.inputedValue = "入力してください。";
                  });
                }
              },
            ),
            /*
            Text(
              'You have pushed the button this many times:',
            ),
             */
            //CanvasMaker(),
            /*
            FutureBuilder(
              future: fCanvasMaker(),
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      width: double.infinity,
                      child: Image.memory(snapshot.data!));
                } else {
                  return Text("データが存在しません");
                }
              },
            ),

             */
            //ImageCropper(),
            ElevatedButton(
              child: Text("ボタン"),
              onPressed: () {
                FutureBuilder(
                  future: imagePick(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Uint8List> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          width: double.infinity,
                          child: Image.memory(snapshot.data!));
                    } else {
                      return Text("データが存在しません");
                    }
                  },
                );
              },
            ),
            ElevatedButton(
                onPressed: () {
                  upLoad();
                },
                child: Text("アップロード")),
            ElevatedButton(
                onPressed: () {
                  imagePick2();
                },
                child: Text("imagePick2")),
            bytes != null
                ? SizedBox(
                    width: deviceWidth * 0.5,
                    height: deviceHeight * 0.5,
                    child: Image.memory(bytes!))
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: deviceWidth * 0.25,
                  height: deviceHeight * 0.25,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: AspectRatio(
                        aspectRatio: 8/9,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                //画像の短い方の辺で合わせてくれる
                                  fit: BoxFit.cover,
                                  image: AssetImage("images/syamiko2.jpeg"))),
                        )),
                  ),
                ),
                Container(
                  width: deviceWidth * 0.25,
                  height: deviceHeight * 0.25,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: AspectRatio(
                        aspectRatio: 8/9,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.black,
                                child: Text("しゃみこが悪いんだよ",textAlign: TextAlign.center,),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              color: Colors.black,
                              child: Text("みかん",),
                            ),
                          ],
                        )),
                  ),
                )
              ],
            ),
            ElevatedButton(onPressed: (){
              //inputedValueをわたす
            }, child: Text("完成！"))
          ],
        ),
      ),
    );
  }
}
