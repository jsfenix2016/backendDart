import 'dart:convert';
import 'package:mysql1/mysql1.dart';
import 'package:pruebabackend/bin/pettype.dart';
import 'package:pruebabackend/bin/user.dart';

JsonCodec codec = JsonCodec();

class PetQuery {
  Future<String> AllPet(MySqlConnection conection) async {
    try {
      var a = await conection.query('CALL SP_consultTypePet()');

      var dto = <PetType>[];
      for (var row in a) {
        print('Name: ${row[1]}');

        dto.add(PetType(IdPet: row[0], Name: row[1]));
      }

      return ('${codec.encode(dto)}');
    } catch (error) {
      print(error.toString());
      return ('jsonResponse: $error');
    }
  }

  Future<String> PetPost(MySqlConnection connection, Map data) async {
    try {
      var idType = data['idType'];

      var a = await connection.query('CALL SP_consultRace()');

      var dto = <User>[];
      for (var row in a) {
        idType = row[0];
        dto.add(User(IdUser: row[0], Email: row[1], Image_1: row[5]));
      }

      final jsonResponse = codec.encode(dto);
      return ('$jsonResponse');
    } catch (error) {
      print(error.toString());
      return ('jsonResponse: $error');
    }
  }

   Future<String> PetSave(MySqlConnection connection, Map data) async {
          var iduser = data['IdUser'];
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
                'CALL SP_InsertPet("$iduser", "$namePet", $birthDate, "$idRace", "$image_1", "$image_2", "$image_3", "$image_4", "$idPettype", "$description", "$genero", "$isAvailable", "$isTrayed")');

            var idUser = -1;
            
            for (var row in petNew) {
              idUser = row[0];
            }

            final jsonResponse = codec.encode(idUser);
            return ('$jsonResponse');
   }


   Future<String> PetUpdate(MySqlConnection connection, Map data) async {
          var iduser = data['IdUser'];
          var idPet = data['idPet'];
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
                'CALL SP_UpdatePet("$iduser","$idPet", "$namePet", $birthDate, "$idRace", "$image_1", "$image_2", "$image_3", "$image_4", "$idPettype", "$description", "$genero", "$isAvailable", "$isTrayed")');

            var idUser = -1;
            
            for (var row in petNew) {
              idUser = row[0];
            }

            final jsonResponse = codec.encode(idUser);
            return ('$jsonResponse');
   }

}
