import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mysql1/mysql1.dart';
import 'package:path/path.dart';
import 'package:pruebabackend/bin/user.dart';

class ManagerImage {
  JsonCodec codec = JsonCodec();

  //Guardar imagen en un directorio especifico
  Future<String> saveImage(MySqlConnection connection, Map data) async {
    try {
      var imgName = data['imgName'];
      var typeImage = data['typeImage']; // pet or user

      var idUser = data['idUser'];

      var image = data['image'];

      Uint8List _bytesImage;

      _bytesImage = Base64Decoder().convert(image);

      final myDir2 = Directory('dir/$typeImage/$idUser/');
      final file = File(join(myDir2.uri.path, '${imgName}.png'));

      await file.exists().then((isThere) {
        isThere
            ? print('exists')
            : Directory('dir/$typeImage/$idUser/').createSync(recursive: true);
      });

      file.writeAsBytesSync(_bytesImage, mode: FileMode.append);

      var dto = <User>[];

      dto.add(User(Image_1: file.uri.toString()));

      final jsonResponse = codec.encode(dto);

      print('jsonResponse: ${jsonResponse.toString()}');
      return ('$jsonResponse');
    } catch (error) {
      print(error.toString());
      return ('jsonResponse: $error');
    }
  }
}
