import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:pruebabackend/bin/user.dart';

class ManagerImage {
  JsonCodec codec = JsonCodec();

  //Guardar imagen en un directorio especifico
  Future<String> saveImage(Map data) async {
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

  Future<String> searchImage(HttpRequest request) async {
    var imgName = request.uri.queryParameters['imgName'];

    final myDir = Directory(imgName);

    request.response.headers.contentType = ContentType.parse('image/png');

    var filet = await File(myDir.path);

    final bytes = filet.readAsBytesSync();

    var img64 = base64Encode(bytes);

    return '${img64}';
  }

//----- Hay que probar aun ----//
  Future<String> DeleteImage(HttpRequest request) async {
    var imgName = request.uri.queryParameters['imgName'];

    final myDir = Directory(imgName);

    request.response.headers.contentType = ContentType.parse('image/png');

    var filet = await File(myDir.path);

    final bytes = filet.delete();

    // var img64 = base64Encode(bytes);

    return '${bytes}';
  }
}

// --- esto en main si se quiere usar :p --//
// case '/PeliWeb':
      //   if (request.method == 'GET') {
      //     final myDir = Directory(
      //         'dir/ImageUser/slam-dunk-1993-1996-subbed-episodio-072.mp4');

      //     request.response.headers.contentType = ContentType.parse('video/mp4');
 //     request.response.headers.contentType =
      //         ContentType.parse('application/x-rar-compressed');

      //     var filet = await File(myDir.path);
      //     var fileStream = filet.openRead();

      //     await request.response.addStream(fileStream);

      //     await request.response.close();
      //   }
      //   break;
      // case '/imageWeb':
      //   if (request.method == 'GET') {
      //     var l = await dirContents(Directory('dir/ImageUser/50'));

      //     // request.response
      //     //   ..headers.set('Content-Type', lookupMimeType(l.first.path));
      //     var imgName = request.uri.queryParameters['imgName'];

      //     final myDir = Directory('dir/ImageUser/50/12.png');

      //     request.response.headers.contentType = ContentType.parse('image/png');

      //     var filet = await File(myDir.path);
      //     var fileStream = filet.openRead();

      //     await request.response.addStream(fileStream);

      //     await request.response.close();
      //     // ShowWebImage().showImageInWeb(l);
      //   }
      //   break;