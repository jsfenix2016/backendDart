import 'dart:convert';
import 'package:mysql1/mysql1.dart';
import 'package:pruebabackend/bin/pet.dart';
import 'package:pruebabackend/bin/pettype.dart';
import 'package:pruebabackend/bin/user.dart';

JsonCodec codec = JsonCodec();

class PetQuery {
  Future<String> AllPet(MySqlConnection conection) async {
    try {
      var idUser = 53;
      // data['IdUser'];

      var isAvailable = true;
      //data['IsAvailable'];
      // var isTrayed = false;
      //data['IsTrayed'];

      var AllPet =
          await conection.query('CALL SP_consultPet($idUser,  $isAvailable)');

      var dto = <Pet>[];
      for (var row in AllPet) {
        dto.add(Pet(
            IdPet: row[0],
            IdUser: row[1],
            NamePet: row[2],
            BirthDate:
                "${DateTime.parse(row[3]).year.toString()}-${DateTime.parse(row[3]).month.toString().padLeft(2, '0')}-${DateTime.parse(row[3]).day.toString().padLeft(2, '0')}",
            IdRace: row[4],
            Image_1: row[5],
            Image_2: row[6],
            Image_3: row[7],
            Image_4: row[8],
            IdPettype: row[9],
            Description: row[10],
            IsAvailable: row[11],
            Genero: row[12],
            IsTrayed: row[13]));
      }

      final jsonResponse = codec.encode(dto);

      return ('${jsonResponse}');
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
      var datew =
          "${birthDate.year.toString()}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}";
      var parsedDate = DateTime.parse(datew);
      // producto.idUser = 50; //pref.idUser;
      // producto.name = "lilo";
      // producto.descMascota = "bueno";
      // producto.idRaza = 1;

      // producto.disponible = true;
      // producto.idEspecie = 1;
      // producto.tamano = "pequeño";
      // producto.genero = "macho";

      // producto.enfermedad = false;
      // producto.pedigree = true;
      print(datew);
      var petNew = await connection.query(
          'CALL SP_InsertPet($idUser, "$name", "$datew", $idRace, "$image_1", "$image_2", "$image_3", "$image_4", $idPettype, "$description", $isAvailable, "$genero", $isTrayed)');
      print(birthDate);
      var idUserTemp = -1;

      for (var row in petNew) {
        idUserTemp = row[0];
      }

      final jsonResponse = codec.encode(idUserTemp);
      return ('jsonResponse: $jsonResponse');
    } catch (error) {
      print(error.toString());
      return ('jsonResponse: $error');
    }
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
