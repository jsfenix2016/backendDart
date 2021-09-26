import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:mysql1/mysql1.dart';
import 'package:path/path.dart';
import 'package:pruebabackend/bin/user.dart';
import 'ManagerImage.dart';
import 'PetQuery.dart';
import 'UserQuery.dart';

JsonCodec codec = JsonCodec();
var connection;

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

    switch (request.uri.path) {
      case '/imageSa':
        if (request.method == 'GET') {
          var img = ManagerImage().searchImage(request);

          await request.response.write(img);
          await connection.close();
          break;
        }

        if (request.method == 'POST') {
          var data = await methodData(request);
          var a = ManagerImage().saveImage(data);

          print('jsonResponse: ${a.toString()}');
          await request.response.write(a.toString());

          await connection.close();
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
          var data = await methodData(request);
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
            // var content = await utf8.decoder.bind(request).join(); /*2*/
            // var data = jsonDecode(content) as Map; /*3*/
            var data = await methodData(request);
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
          // var content = await utf8.decoder.bind(request).join(); /*2*/
          // var data = jsonDecode(content) as Map; /*3*/

          try {
            var data = await methodData(request);
            var a = await user.PetRacePost(connection, data);

            final jsonResponse = codec.encode(a);

            await request.response.write('$jsonResponse');
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }
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
          // var content = await utf8.decoder.bind(request).join(); /*2*/
          // var data = jsonDecode(content) as Map; /*3*/
          var a = await pet.AllPet(connection);
          await request.response.write('$a');
          await connection.close();
        } else if (request.method == 'POST') {
          // var content = await utf8.decoder.bind(request).join(); /*2*/
          // var dataa = jsonDecode(content) as Map; /*3*/
          var data = await methodData(request);
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
          // var content = await utf8.decoder.bind(request).join(); /*2*/
          // var data = jsonDecode(content) as Map; /*3*/
          var data = await methodData(request);
          var a = await pet.PetSave(connection, data);
          await request.response.write('$a');

          await connection.close();
        } else if (request.method == 'PUT') {
          try {
            // var content = await utf8.decoder.bind(request).join(); /*2*/
            // var data = jsonDecode(content) as Map; /*3*/
            var data = await methodData(request);
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
            //  var content = await utf8.decoder.bind(request).join(); /*2*/
            var data =
                await methodData(request); //jsonDecode(content) as Map; /*3*/

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
