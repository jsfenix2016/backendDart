import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'ManagerImage.dart';
import 'PetQuery.dart';
import 'UserQuery.dart';

JsonCodec codec = JsonCodec();
var connection;

Future main() async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8088);
  print('Serving at ${server.address}:${server.port}');

  server.listen((HttpRequest request) async {
    connection = await MySqlConnection.connect(ConnectionSettings(
      host: 'localhost',
      port: 8889,
      user: 'JsFenix',
      password: 'Js1234567/',
      db: 'bdPestNewVersion',
    ));

    switch (request.uri.path) {
      case '/imageSa':
        if (request.method == 'GET') {
          try {
            var img = await ManagerImage().searchImage(request);
            print('jsonResponse: ${img.toString()}');
            await request.response.write(img.toString());
            await connection.close();
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }
          break;
        }

        if (request.method == 'POST') {
          try {
            var data = await methodData(request);
            var a = await ManagerImage().saveImage(data);

            print('jsonResponse: ${a.toString()}');
            await request.response.write(a.toString());

            await connection.close();
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }
          break;
        }
        break;

      case '/Login':
        if (request.method == 'POST') {
          try {
            var data = await methodData(request);

            var responseLogin = await UserQuery().Login(connection, data);

            await request.response.write(responseLogin.toString());
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }
          await connection.close();
          break;
        }

        break;

      case '/registro':
        if (request.method == 'GET') {
          // var a = await connection.query('CALL SP_consultRegister()');
        } else if (request.method == 'POST') {
          try {
            var data = await methodData(request);
            var req = UserQuery().Register(connection, data);

            await request.response.write('jsonResponse: $req');
            await connection.close();
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }
          break;
        } else if (request.method == 'PUT') {}

        break;
      case '/consultUser':
        if (request.method == 'GET') {
          // await request.response.write(File('indexImg.html'));
        } else if (request.method == 'POST') {
          try {
            var data = await methodData(request);
            var req = await UserQuery().UserGet(connection, data);

            await request.response.write('$req');
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
        } else if (request.method == 'POST') {
          try {
            var data = await methodData(request);
            var a = await user.PetRacePost(connection, data);

            //final jsonResponse = codec.encode(a);

            await request.response.write('$a');
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }
        } else if (request.method == 'PUT') {}
        break;

      case '/consultPet':
        var pet = PetQuery();
        if (request.method == 'GET') {
        } else if (request.method == 'POST') {
          try {
            var data = await methodData(request);
            var a = await pet.AllPet(connection, data);
            await request.response.write('$a');
            await connection.close();
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }
        } else if (request.method == 'PUT') {}
        break;
      case '/savePet':
        var pet = PetQuery();
        if (request.method == 'GET') {
        } else if (request.method == 'POST') {
          try {
            var data = await methodData(request);
            var a = await pet.PetSave(connection, data);
            await request.response.write('$a');

            await connection.close();
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }
        } else if (request.method == 'PUT') {
          try {
            var data = await methodData(request);
            var req = await pet.PetUpdate(connection, data);

            await request.response.write('$req');
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }

          await connection.close();
        } else if (request.method == 'DELETE') {
          try {
            var data = await methodData(request);
            var req = await pet.DeletePet(connection, data);

            await request.response.write('$req');
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

Future<Map> methodData(HttpRequest request) async {
  var content = await utf8.decoder.bind(request).join(); /*2*/
  return jsonDecode(content) as Map; /*3*/
}

//-- esto es para buscar la lista de archivos que se encuentran en el directorio especifico --- //
Future<List<FileSystemEntity>> dirContents(Directory dir) {
  var files = <FileSystemEntity>[];
  var completer = Completer<List<FileSystemEntity>>();
  var lister = dir.list(recursive: false);
  lister.listen((file) => files.add(file),
      // should also register onError
      onDone: () => completer.complete(files));
  return completer.future;
}

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
      //   }
      //   break;

// case '/dateTime':
      //   if (request.method == 'GET') {
      //     var now = DateTime.now().toLocal();
      //     var isAlgo = true;
      //     var datew =
      //         "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      //     var parsedDate = DateTime.parse(datew);

      //     try {
      //       var petNew = await connection
      //           .query('CALL SP_insertDateTime( "$now", $isAlgo)');

      //       await request.response.write('jsonResponse: ok');
      //     } catch (error) {
      //       print(error.toString());
      //       await request.response.write('jsonResponse: $error');
      //     }

      //     await connection.close();
      //   }
      //   break;