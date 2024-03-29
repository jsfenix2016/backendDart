import 'dart:convert';
import 'package:mysql1/mysql1.dart';
import 'package:pruebabackend/bin/pet.dart';
// import 'package:pruebabackend/bin/pettype.dart';
import 'package:pruebabackend/bin/race.dart';
import 'package:pruebabackend/bin/user.dart';

JsonCodec codec = JsonCodec();

class PetQuery {
  Future<String> AllPet(MySqlConnection conection, Map data) async {
    try {
      var idUser = data['idUser'];

      var isAvailable = true;
      //data['IsAvailable'];
      // var isTrayed = false;
      //data['IsTrayed'];

      var AllPet =
          await conection.query('CALL SP_consultPet($idUser,  $isAvailable)');

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

  Future<String> AllMyPet(MySqlConnection conection, Map data) async {
    try {
      var idUser = data['idUser'];

      var AllPet = await conection.query('CALL SP_consultMyPet($idUser)');

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

//Falta terminar y probar
  Future<String> PetRacePost(MySqlConnection connection) async {
    try {
      //var idType = data['idType'];

      var req = await connection.query('CALL SP_consultRace()');

      var dto = <Race>[];
      req.forEach((element) {
        dto.add(
            Race(IdPet: element[0], IdPettype: element[1], Name: element[2]));
      });

      final jsonResponse = codec.encode(dto);
      return ('${jsonResponse.toString()}');
    } catch (error) {
      print(error.toString());
      return ('jsonResponse: $error');
    }
  }

//////////
  Future<String> PetSave(MySqlConnection connection, Map data) async {
    try {
      var idUser = data['idUser'];
      var idRace = data['raza'];
      var idPettype = data['especie'];

      var name = data['name'];
      var birthDate = DateTime.parse(data['birthDay']);

      var image_1 = data['fotoUrl'];
      var image_2 = data['Image_2'];
      var image_3 = data['Image_3'];
      var image_4 = data['Image_4'];

      var description = data['Description'];
      var genero = data['genero'];

      var isAvailable = true;
      // data['IsAvailable'];
      var isTrayed = data['istrayed'];
      var idSize = data['idSize'];

      var datew =
          "${birthDate.year.toString()}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}";

      print(datew);
      var petNew = await connection.query(
          'CALL SP_InsertPet($idUser, "$name", "$datew", $idRace, "$image_1", "$image_2", "$image_3", "$image_4", $idPettype, "$description", $isAvailable, "$genero", $isTrayed, $idSize)');
      print(birthDate);
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

  Future<String> PetUpdate(MySqlConnection connection, Map data) async {
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

  /*------   LIKE   -------*/
  Future<String> PetSaveLike(MySqlConnection connection, Map data) async {
    try {
      var idUser = data['idUser'];
      var idOtherUser = data['idOtherUser'];

      var idPet = data['idPet'];
      var idOtherPet = data['idOtherPet'];
      var matchUser = data['matchUser'];

      var save = await connection.query(
          'CALL SP_InsertLike($idUser,$idOtherUser, $idPet,$idOtherPet,$matchUser)');

      var dto = <User>[];
      // for (var row in a) {
      //   idType = row[0];
      //   dto.add(User(IdUser: row[0], Email: row[1], Image_1: row[5]));
      // }

      final jsonResponse = codec.encode(dto);
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

  Future<String> DeletePet(MySqlConnection connection, Map data) async {
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

  Future<String> MyPets(MySqlConnection connection, Map data) async {
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
