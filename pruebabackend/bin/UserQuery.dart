import 'dart:convert';
import 'package:mysql1/mysql1.dart';
import 'package:pruebabackend/bin/userRegister.dart';

JsonCodec codec = JsonCodec();

class UserQuery {
  Future<String> UserGet(MySqlConnection conection) async {
    try {
      var idUser = 50; // data['IdUser'];

      return ('jsonResponse: $idUser');
    } catch (error) {
      print(error.toString());
      return ('jsonResponse: $error');
    }
  }

  Future<String> Register(MySqlConnection connection, Map data) async {
    try {
      var user = data['email'];
      var pass = data['pass'];
      var terms = data['terms'];
      var imgDir = data['image_1'];

      // code that might throw an exception
      print('Name: ${user}, email: ${pass}, terms: ${terms}');

      await connection
          .query('CALL SP_InsertRegister("$user", "$pass", $terms, "$imgDir")');

      var consultNewReg =
          await connection.query('CALL consultaRegistro("$user")');

      var idUser = -1;

      for (var row in consultNewReg) {
        print('Name: ${row[0]}');
        idUser = row[0];
      }

      final jsonResponse = codec.encode(idUser);

      print('$jsonResponse');

      return ('$jsonResponse');
    } catch (error) {
      print(error.toString());
      return ('jsonResponse: $error');
    }
  }

  Future<String> Login(MySqlConnection connection, Map data) async {
    try {
      var user = data['email'];
      var pass = data['pass'];

      // code that might throw an exception
      print('email: ${user}, pass: ${pass}');

      var getRequest =
          await connection.query('CALL SP_validateUser("$user", "$pass")');

      var dto = <UserRegister>[];

      for (var row in getRequest) {
        print('email: ${row[1]}, pass: ${row[2]}, terms: ${row[3]}');
        dto.add(UserRegister(IdUser: row[0], Email: row[1]));
      }

      final jsonResponse = codec.encode(dto);

      print('jsonResponse: ${jsonResponse.toString()}');
      return jsonResponse;
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  Future<String> ChangePassword(MySqlConnection connection, Map data) async {
    try {
      var user = data['email'];
      var pass = data['pass'];

      // code that might throw an exception
      print('email: ${user}, pass: ${pass}');

      var getRequest =
          await connection.query('CALL SP_validateUser("$user", "$pass")');

      var dto = <UserRegister>[];

      for (var row in getRequest) {
        print('email: ${row[1]}, pass: ${row[2]}, terms: ${row[3]}');
        dto.add(UserRegister(IdUser: row[0], Email: row[1]));
      }

      final jsonResponse = codec.encode(dto);

      print('jsonResponse: ${jsonResponse.toString()}');
      return jsonResponse;
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }
}
