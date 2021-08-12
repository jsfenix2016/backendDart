import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'dart:typed_data';

import 'package:mime/mime.dart';
import 'package:mysql1/mysql1.dart';
import 'package:path/path.dart';
import 'package:pruebabackend/bin/pet.dart';
import 'package:pruebabackend/bin/pettype.dart';
import 'package:pruebabackend/bin/user.dart';

import 'package:pruebabackend/bin/userRegister.dart';

import 'PetQuery.dart';
import 'UserQuery.dart';
import 'showWeb.dart';

//import 'dart:convert' as JSON;

//final File file = File('indexImg.html');
JsonCodec codec = JsonCodec();
var connection;
Future<List<FileSystemEntity>> dirContents(Directory dir) {
  var files = <FileSystemEntity>[];
  var completer = Completer<List<FileSystemEntity>>();
  var lister = dir.list(recursive: false);
  lister.listen((file) => files.add(file),
      // should also register onError
      onDone: () => completer.complete(files));
  return completer.future;
}

Future main() async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8089);
  print('Serving at ${server.address}:${server.port}');

  server.listen((HttpRequest request) async {
    connection = await MySqlConnection.connect(ConnectionSettings(
      host: 'localhost',
      port: 8889,
      user: 'JsFenix',
      password: 'Js1234567/',
      db: 'bdPestNewVersion',
    ));
    // var filet = await File('bin/indexImg.html');

    switch (request.uri.path) {
      case '/imageSa':
        if (request.method == 'GET') {
          var imgName = request.uri.queryParameters['imgName'];
          // var idUser = request.uri.queryParameters['idUser'];

          // final myDir =  Directory('dir/ImageUser/47/${imgName}.png');
          final myDir = Directory(imgName);

          // final myDir = Directory('dir/ImageUser/50/' + imgName+'.png');
          request.response.headers.contentType = ContentType.parse('image/png');

          // if (await Directory(myDir.path).exists()) {
          var filet = await File(myDir.path);

          // Future fileTemp = filet.readAsBytes();

          final bytes = filet.readAsBytesSync();

          var img64 = base64Encode(bytes);

          await request.response.write('${img64}');

          await connection.close();
          break;
        }

        if (request.method == 'POST') {
          var content = await utf8.decoder.bind(request).join(); /*2*/
          var data = jsonDecode(content) as Map; /*3*/

          var idUser = data['idUser'];
          var imgName = data['user'];
          var image = data['image'];

          Uint8List _bytesImage;

          _bytesImage = Base64Decoder().convert(image);

          // var file =  File('dir/ImageUser/$idUser.png');

          final myDir2 = Directory('dir/ImageUser/$idUser/');
          final file = File(join(myDir2.uri.path, '${imgName}.png'));

          await file.exists().then((isThere) {
            isThere ? print('exists') : print('non-existent');
          });

          Directory('dir/ImageUser/$idUser').createSync(recursive: true);

          file.writeAsBytesSync(_bytesImage, mode: FileMode.append);

          var dto = <User>[];

          dto.add(User(Image_1: file.uri.toString()));

          final jsonResponse = codec.encode(dto);

          print('jsonResponse: ${jsonResponse.toString()}');
          await request.response.write(jsonResponse.toString());

          await connection.close();
          break;
        }
        break;
      // case '/PeliWeb':
      //   if (request.method == 'GET') {
      //     final myDir = Directory(
      //         'dir/ImageUser/slam-dunk-1993-1996-subbed-episodio-072.mp4');

      //     request.response.headers.contentType = ContentType.parse('video/mp4');

      //     var filet = await File(myDir.path);
      //     var fileStream = filet.openRead();

      //     await request.response.addStream(fileStream);

      //     await request.response.close();
      //   }
      //   break;
      case '/imageWeb':
        if (request.method == 'GET') {
          var l = await dirContents(Directory('dir/ImageUser/50'));

          // request.response
          //   ..headers.set('Content-Type', lookupMimeType(l.first.path));
          var imgName = request.uri.queryParameters['imgName'];

          final myDir = Directory('dir/ImageUser/50/12.png');

          request.response.headers.contentType = ContentType.parse('image/png');

          var filet = await File(myDir.path);
          var fileStream = filet.openRead();

          await request.response.addStream(fileStream);

          await request.response.close();
          // ShowWebImage().showImageInWeb(l);
        }
        break;
      case '/Login':
        if (request.method == 'POST') {
          try {
            var content = await utf8.decoder.bind(request).join(); /*2*/
            var data = jsonDecode(content) as Map; /*3*/

            var login = UserQuery();

            var responseLogin = await login.Login(connection, data);

            await request.response.write(responseLogin.toString());
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }
          await connection.close();
          break;
        }

        break;
      case '/consultPets':
        if (request.method == 'POST') {
          try {
            var a = await connection.query('CALL SP_consultPet()');

            for (var row in a) {
              print('Name: ${row[0]}, email: ${row[1]}');
            }

            await request.response.write('jsonResponse: ${a}');
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }
        }
        break;
      case '/registro':
        if (request.method == 'GET') {
          var a = await connection.query('CALL SP_consultRegister()');
        } else if (request.method == 'POST') {
          var content = await utf8.decoder.bind(request).join(); /*2*/
          var data = jsonDecode(content) as Map; /*3*/

          var user = data['email'];
          var pass = data['pass'];
          var terms = data['terms'];
          var imgDir = data['image_1'];

          print('Name: ${user}, email: ${pass}, terms: ${terms}');

          try {
            await connection.query(
                'CALL SP_InsertRegister("$user", "$pass", $terms, "$imgDir")');

            var consultNewReg =
                await connection.query('CALL consultaRegistro("$user")');

            var idUser = -1;

            for (var row in consultNewReg) {
              print('Name: ${row[0]}');
              idUser = row[0];
            }

            final jsonResponse = codec.encode(idUser);

            print('$jsonResponse');

            await request.response.write('$jsonResponse');
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }

          await connection.close();

          break;
        } else if (request.method == 'PUT') {}

        break;
      case '/consultUser':
        if (request.method == 'GET') {
          await request.response.write(File('indexImg.html'));
        } else if (request.method == 'POST') {
          try {
            var content = await utf8.decoder.bind(request).join(); /*2*/
            var data = jsonDecode(content) as Map; /*3*/

            var idUser = data['idUser'];

            // code that might throw an exception
            print('idUser: ${idUser}');

            var a = await connection.query('CALL SP_consultUser($idUser)');

            var dto = <User>[];
            for (var row in a) {
              print('Name: ${row[0]}');
              idUser = row[0];
              dto.add(User(IdUser: row[0], Email: row[1], Image_1: row[5]));
            }

            final jsonResponse = codec.encode(dto);

            print('$jsonResponse');

            await request.response.write('$jsonResponse');
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }

          await connection.close();
        }
        break;

      case '/pettype':
        var user = PetQuery();
        if (request.method == 'GET') {
          // var a = await user.AllPet(connection);
          // await request.response.write('${a}');
          // await connection.close();
        } else if (request.method == 'POST') {
          var content = await utf8.decoder.bind(request).join(); /*2*/
          var data = jsonDecode(content) as Map; /*3*/

          var a = await user.PetPost(connection, data);

          final jsonResponse = codec.encode(a);

          await request.response.write('$jsonResponse');
        } else if (request.method == 'PUT') {}
        break;
      case '/dateTime':
        if (request.method == 'GET') {
          var now = DateTime.now().toLocal();
          var isAlgo = true;
          var datew =
              "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

          var parsedDate = DateTime.parse(datew);

          try {
            var petNew = await connection
                .query('CALL SP_insertDateTime( "$now", $isAlgo)');

            await request.response.write('jsonResponse: ok');
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }

          await connection.close();
        }
        break;
      case '/consult':
        if (request.method == 'GET') {
        } else if (request.method == 'POST') {
        } else if (request.method == 'PUT') {}
        break;
      case '/consultPet':
        var pet = PetQuery();
        if (request.method == 'GET') {
          var content = await utf8.decoder.bind(request).join(); /*2*/
          // var data = jsonDecode(content) as Map; /*3*/
          var a = await pet.AllPet(connection);
          await request.response.write('$a');
          await connection.close();
        } else if (request.method == 'POST') {
          var content = await utf8.decoder.bind(request).join(); /*2*/
          var dataa = jsonDecode(content) as Map; /*3*/
          var a = await pet.AllPet(connection);
          await request.response.write('$a');
          await connection.close();
        } else if (request.method == 'PUT') {}
        break;
      case '/savePet':
        var pet = PetQuery();
        if (request.method == 'GET') {
          // var a = await user.AllPet(connection);
          // await request.response.write('$a');

        } else if (request.method == 'POST') {
          var content = await utf8.decoder.bind(request).join(); /*2*/
          var data = jsonDecode(content) as Map; /*3*/
          var a = await pet.PetSave(connection, data);
          await request.response.write('$a');

          await connection.close();
        } else if (request.method == 'PUT') {
          try {
            var content = await utf8.decoder.bind(request).join(); /*2*/
            var data = jsonDecode(content) as Map; /*3*/

            var namePet = data['NamePet'];
            var birthDate = data['BirthDate'];
            var idRace = data['IdRace'];

            var image_1 = data['Image_1'];
            var image_2 = data['Image_2'];
            var image_3 = data['Image_3'];
            var image_4 = data['Image_4'];
            var idPettype = data['IdPettype'];
            var description = data['Description'];
            var genero = data['Genero'];

            var isAvailable = data['IsAvailable'];
            var isTrayed = data['IsTrayed'];

            var petNew = await connection.query(
                'CALL SP_UpdatePet("$namePet", $birthDate, "$idRace", "$image_1", "$image_2", "$image_3", "$image_4", "$idPettype", "$description", "$genero", "$isAvailable", "$isTrayed")');

            await request.response.write('jsonResponse: ok');
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }

          await connection.close();
        } else if (request.method == 'DELETE') {
          try {
            var content = await utf8.decoder.bind(request).join(); /*2*/
            var data = jsonDecode(content) as Map; /*3*/

            var idPet = data['idPet'];

            await connection.query('CALL SP_DeletePet("$idPet")');

            await request.response.write('jsonResponse: ok');
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }

          await connection.close();
        }
        break;

      default:
        request.response
          ..statusCode = HttpStatus.notFound
          ..write('not Found')
          ..close();
        break;
    }
    await request.response.close();
  });
}
