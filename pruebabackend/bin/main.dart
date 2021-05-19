import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';

import 'package:mysql1/mysql1.dart';
import 'package:path/path.dart';
import 'package:pruebabackend/bin/pet.dart';
import 'package:pruebabackend/bin/pettype.dart';
import 'package:pruebabackend/bin/user.dart';

import 'package:pruebabackend/bin/userRegister.dart';

import 'PetQuery.dart';
//import 'dart:convert' as JSON;

//final File file = File('index.html');
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
      db: 'searchPet',
    ));

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
          //  print('jsonResponse: ${img64}');

          await request.response.write('${img64}');

          // var dto = <User>[];

          // dto.add(User(Image_1: img64));

          // final jsonResponse = codec.encode(dto);
          // await request.response.write(jsonResponse.toString());
          // // await request.response
          //     .addStream(fileTemp.asStream())
          //     .whenComplete(() {
          //   request.response.close();
          // });
          // } else {
          //   request.response.headers.contentType = ContentType.parse('json');
          //   await request.response.write('no exite la imagen');
          // }

          break;
        }

        if (request.method == 'POST') {
          var content = await utf8.decoder.bind(request).join(); /*2*/
          var data = jsonDecode(content) as Map; /*3*/

          var idUser = data['idUser'];
          var imgName = data['user'];
          var image = data['image'];
          //final decodedBytes = base64Decode(image);

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

          // await myDir.exists().then((isThere) {
          //   if (isThere) {
          //     print('exists');
          //     final file = File(join(myDir.uri.path));
          //     Directory('dir/ImageUser/$idUser.png')
          //         .createSync(recursive: true);

          //     file.writeAsBytesSync(decodedBytes);
          //     request.response.write(file.uri);
          //   } else {
          //     final file = File(join(myDir.uri.path));
          //     Directory('dir/ImageUser/$idUser.png')
          //         .createSync(recursive: true);

          //     file.writeAsBytesSync(decodedBytes);
          //     request.response.write(file.uri);
          //   }
          // });

          break;
        }
        break;
      case '/Login':
        if (request.method == 'POST') {
          var content = await utf8.decoder.bind(request).join(); /*2*/
          var data = jsonDecode(content) as Map; /*3*/

          var user = data['email'];
          var pass = data['pass'];

          // code that might throw an exception
          print('email: ${user}, pass: ${pass}');
          try {
            var a = await connection
                .query('CALL SP_validateUser("$user", "$pass")');

            var dto = <UserRegister>[];
            for (var row in a) {
              print('email: ${row[1]}, pass: ${row[2]}, terms: ${row[3]}');
              dto.add(UserRegister(IdUser: row[0], Email: row[1]));
            }

            final jsonResponse = codec.encode(dto);

            print('jsonResponse: ${jsonResponse.toString()}');

            await request.response.write(jsonResponse.toString());
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }
          await connection.close();
          break;
        }

        break;
      case '/consultPets':
        if (request.method == 'GET') {
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

          // var convertTerms = terms == true ? 1 : 0;

          // code that might throw an exception
          print('Name: ${user}, email: ${pass}, terms: ${terms}');

          try {
            await connection.query(
                'CALL SP_InsertRegister("$user", "$pass", $terms, "$imgDir")');

            var consultNewReg =
                await connection.query('CALL consultaRegistro("$user")');

            var idUser = -1;
            //var dto = <UserRegister>[];
            for (var row in consultNewReg) {
              print('Name: ${row[0]}');
              idUser = row[0];
              //  dto.add(UserRegister(
              //       IdUser: row[0],
              //       Email: row[1],
              //       Terms: row[3]));

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
        } else if (request.method == 'PUT') {
          //   var idUser = int.parse(request.uri.queryParameters['idUser']);
          //   var user = request.uri.queryParameters['email'];
          //   var pass = int.parse(request.uri.queryParameters['pass']);
          //   var terms = (request.uri.queryParameters['terms']);

          //   connection = await MySqlConnection.connect(ConnectionSettings(
          //     host: 'localhost',
          //     port: 8889,
          //     user: 'JsFenix',
          //     password: 'Js1234567/',
          //     db: 'searchPet',
          //   ));

          //   var results = await connection
          //       .query('select * from user where email = "$user"');

          //   var dto = <User>[];
          //   for (var row in results) {
          //     print('Name: ${row[0]}, email: ${row[1]}');
          //     dto.add(User(
          //         IdUser: row[0],
          //         LastName: row[1],
          //         FirstName: row[2],
          //         Email: row[3],
          //         Telephone: row[4]));
          //   }

          //   if (dto.length >= 1) {
          //     print('jsonResponse: KO');
          //     await request.response.write('KO');
          //   } else {
          //     await connection.query(
          //         'INSERT INTO RegistroUser (idRegUser, email, pass, termsconditions) VALUES ("$idUser","$user", "$pass", $terms) ');

          //     await connection.query(
          //         'INSERT INTO user (email, pass) VALUES ("$idUser", "$pass", $terms) ');

          //     // Finally, close the connection
          //     var resultsId = await connection
          //         .query('select * from user where email = "$user"');
          //     await connection.close();

          //     final jsonResponse = codec.encode(dto);

          //     print('jsonResponse: ${jsonResponse.toString()}');
          //     await request.response
          //         .write('jsonResponse: ${jsonResponse.toString()}');
          //   }
        }

        break;
      case '/consultUser':
        if (request.method == 'GET') {
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
          var a = await user.AllPet(connection);
          await request.response.write('${a}');
          await connection.close();
        } else if (request.method == 'POST') {
          var content = await utf8.decoder.bind(request).join(); /*2*/
          var data = jsonDecode(content) as Map; /*3*/

          var a = await user.PetPost(connection, data);
          // try {
          //   var content = await utf8.decoder.bind(request).join(); /*2*/
          //   var data = jsonDecode(content) as Map; /*3*/

          //   var idType = data['idType'];

          //   var a = await connection.query('CALL SP_consultRace()');

          //   var dto = <User>[];
          //   for (var row in a) {

          //     idType = row[0];
          //     dto.add(User(IdUser: row[0], Email: row[1], Image_1: row[5]));
          //   }

          final jsonResponse = codec.encode(a);

          await request.response.write('$jsonResponse');
          // } catch (error) {
          //   print(error.toString());
          //   await request.response.write('jsonResponse: $error');
          // }

          // await connection.close();
        } else if (request.method == 'PUT') {}
        break;

      case '/consult':
        if (request.method == 'GET') {
        } else if (request.method == 'POST') {
        } else if (request.method == 'PUT') {}
        break;

      case '/savePet':
        var user = PetQuery();
        if (request.method == 'GET') {
        } else if (request.method == 'POST') {
          var content = await utf8.decoder.bind(request).join(); /*2*/
          var data = jsonDecode(content) as Map; /*3*/
          var a = await user.PetPost(connection, data);
          await request.response.write('$a');

          // var iduser = data['IdUser'];
          // var namePet = data['NamePet'];
          // var birthDate = data['BirthDate'];
          // var idRace = data['IdRace'];

          // var image_1 = data['Image_1'];
          // var image_2 = data['Image_2'];
          // var image_3 = data['Image_3'];
          // var image_4 = data['Image_4'];
          // var idPettype = data['IdPettype'];
          // var description = data['Description'];
          // var genero = data['Genero'];

          // var isAvailable = data['IsAvailable'];
          // var isTrayed = data['IsTrayed'];

          // try {
          //   var petNew = await connection.query(
          //       'CALL SP_InsertPet("$iduser", "$namePet", $birthDate, "$idRace", "$image_1", "$image_2", "$image_3", "$image_4", "$idPettype", "$description", "$genero", "$isAvailable", "$isTrayed")');

          //   var idUser = -1;

          //   for (var row in petNew) {
          //     idUser = row[0];
          //   }

          //   final jsonResponse = codec.encode(idUser);

          //   print('$jsonResponse');

          //   await request.response.write('$jsonResponse');
          // } catch (error) {
          //   print(error.toString());
          //   await request.response.write('jsonResponse: $error');
          // }

          await connection.close();
        } else if (request.method == 'PUT') {
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

          try {
            var petNew = await connection.query(
                'CALL SP_UpdatePet("$namePet", $birthDate, "$idRace", "$image_1", "$image_2", "$image_3", "$image_4", "$idPettype", "$description", "$genero", "$isAvailable", "$isTrayed")');

            await request.response.write('jsonResponse: ok');
          } catch (error) {
            print(error.toString());
            await request.response.write('jsonResponse: $error');
          }

          await connection.close();
        } else if (request.method == 'DELETE') {
          var content = await utf8.decoder.bind(request).join(); /*2*/
          var data = jsonDecode(content) as Map; /*3*/

          var idPet = data['idPet'];

          try {
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
