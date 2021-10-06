
import 'dart:typed_data';

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<Uint8List> imagePick()async{
  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
  //print(result);

  Uint8List fileBytes = result!.files.first.bytes!;
  //Uint8List fileBytes2 = result!.files.single.bytes!;
  //print(fileBytes);
  //String fileName = result.files.first.name;
  return fileBytes;
  // Upload file
  //await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);

}

void upLoad() async{
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    Uint8List fileBytes = result.files.first.bytes!;
    String fileName = result.files.first.name;

    // Upload file
    await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);
  }
}