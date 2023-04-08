import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:pruebabackend/bin/petStreet.dart';

JsonCodec codec = JsonCodec();

class LostPetStreetQuery {
  Future<String> AllLostPetStreet() async {
    try {
      final dir = Directory('dir/petsLostStreet/');
      final List<FileSystemEntity> entities = await dir.list().toList();
      final List<PetStreet> listImages = [];

      var a = await entities.forEach((element) async {
        var filet = await File(element.path);
        final bytes = filet.readAsBytesSync();

        var img64 = base64Encode(bytes);
        listImages.add(PetStreet(Image_1: img64));
      });

      return ('$listImages');
    } catch (error) {
      print(error.toString());
      return ('jsonResponse: $error');
    }
  }
}
