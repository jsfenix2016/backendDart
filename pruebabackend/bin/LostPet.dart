import 'dart:convert';
import 'package:mysql1/mysql1.dart';
import 'package:pruebabackend/bin/pet.dart';

JsonCodec codec = JsonCodec();

class LostPetQuery {
  Future<String> AllLostPet(MySqlConnection conection) async {
    try {
      var AllPet = await conection.query('CALL SP_consultLostPet()');

      var dto = <Pet>[];
      AllPet.forEach((element) {
        dto.add(Pet(
            IdPet: element[0],
            IdUser: element[1],
            NamePet: element[2],
            BirthDate:
                "${DateTime.parse(element[3]).year.toString()}-${DateTime.parse(element[3]).month.toString().padLeft(2, '0')}-${DateTime.parse(element[3]).day.toString().padLeft(2, '0')}",
            IdRace: element[4],
            Image_1: element[5],
            Image_2: element[6],
            Image_3: element[7],
            Image_4: element[8],
            IdPettype: element[9],
            Description: element[10],
            IsAvailable: element[11],
            Genero: element[12],
            IsTrayed: element[13],
            IdSize: element[14]));
      });

      final jsonResponse = codec.encode(dto);

      return ('${jsonResponse.toString()}');
    } catch (error) {
      print(error.toString());
      return ('jsonResponse: $error');
    }
  }

//////////
  Future<String> LostPetSave(MySqlConnection connection, Map data) async {
    try {
      var idUser = data['idUser'];
      var idPet = data['idPet'];

      // var birthDate = DateTime.parse(data['birthDay']);

      var description = data['Description'];

      var isTrayed = data['istrayed'];

      // var datew =
      //     "${birthDate.year.toString()}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}";

      // print(datew);
      var petNew = await connection.query(
          'CALL SP_InsertLostPet($idUser,   "$description",  $isTrayed)');
      // print(birthDate);
      var idUserTemp = -1;
      petNew.forEach((element) {
        idUserTemp = element[0];
      });

      final jsonResponse = codec.encode(idUserTemp);
      return ('jsonResponse: ${jsonResponse.toString()}');
    } catch (error) {
      print(error.toString());
      return ('jsonResponse: $error');
    }
  }

  Future<String> LostPetUpdate(MySqlConnection connection, Map data) async {
    try {
      var iduser = data['idUser'];
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
      var idSize = data['idSize'];
      var petNew = await connection.query(
          'CALL SP_UpdatePet("$iduser","$idPet", "$namePet", $birthDate, "$idRace", "$image_1", "$image_2", "$image_3", "$image_4", "$idPettype", "$description", "$genero", "$isAvailable", "$isTrayed", "$idSize")');

      var idUser = -1;
      petNew.forEach((element) {
        idUser = element[0];
      });

      final jsonResponse = codec.encode(idUser);
      return ('${jsonResponse.toString()}');
    } catch (error) {
      print(error.toString());
      return ('jsonResponse: $error');
    }
  }

  Future<String> AllPetLike(MySqlConnection connection, Map data) async {
    try {
      var idUser = data['idUser'];

      var AllPetLike = await connection.query('CALL SP_consultLike($idUser)');

      var dto = <Pet>[];

      AllPetLike.forEach((element) {
        dto.add(Pet(
            IdPet: element[0],
            IdUser: element[1],
            NamePet: element[2],
            BirthDate:
                "${DateTime.parse(element[3]).year.toString()}-${DateTime.parse(element[3]).month.toString().padLeft(2, '0')}-${DateTime.parse(element[3]).day.toString().padLeft(2, '0')}",
            IdRace: element[4],
            Image_1: element[5],
            Image_2: element[6],
            Image_3: element[7],
            Image_4: element[8],
            IdPettype: element[9],
            Description: element[10],
            IsAvailable: element[11],
            Genero: element[12],
            IsTrayed: element[13]));
      });

      final jsonResponse = codec.encode(dto);

      return ('${jsonResponse.toString()}');
    } catch (error) {
      print(error.toString());
      return ('jsonResponse: $error');
    }
  }

  Future<String> DeleteLostPet(MySqlConnection connection, Map data) async {
    try {
      //  var content = await utf8.decoder.bind(request).join(); /*2*/
      //jsonDecode(content) as Map; /*3*/

      var idPet = data['idPet'];

      await connection.query('CALL SP_DeletePet("$idPet")');

      return ('jsonResponse: ok');
    } catch (error) {
      print(error.toString());
      return ('jsonResponse: $error');
    }
  }
}
