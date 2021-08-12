class Pet {
  final int IdPet;
  final int IdUser;
  final String NamePet;
  final String BirthDate;
  final int IdRace;
  final String Image_1;
  final String Image_2;
  final String Image_3;
  final String Image_4;
  final int IdPettype;
  final String Description;

  final int IsAvailable;
  final String Genero;
  final int IsTrayed;

  Pet(
      {this.IdPet,
      this.IdUser,
      this.NamePet,
      this.BirthDate,
      this.IdRace,
      this.Image_1,
      this.Image_2,
      this.Image_3,
      this.Image_4,
      this.IdPettype,
      this.Description,
      this.IsAvailable,
      this.Genero,
      this.IsTrayed});

  Pet.fromJson(Map<String, dynamic> json)
      : IdPet = json['idPet'],
        IdUser = json['idUser'],
        NamePet = json['name'],
        BirthDate = json['birthDate'],
        IdRace = json['idRace'],
        Image_1 = json['image_1'],
        Image_2 = json['image_2'],
        Image_3 = json['image_3'],
        Image_4 = json['image_4'],
        IdPettype = json['idPettype'],
        Description = json['description'],
        IsAvailable = json['isAvailable'],
        Genero = json['genero'],
        IsTrayed = json['isTrayed'];

  Map<String, dynamic> toJson() => {
        'idPet': IdPet,
        'idUser': IdUser,
        'name': NamePet,
        'birthDate': BirthDate,
        'idRace': IdRace,
        'image_1': Image_1,
        'image_2': Image_2,
        'image_3': Image_3,
        'image_4': Image_4,
        'idPettype': IdPettype,
        'description': Description,
        'isAvailable': IsAvailable,
        'genero': Genero,
        'isTrayed': IsTrayed
      };
}
