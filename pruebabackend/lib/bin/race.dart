class Race {
  final int IdPet;
  final String Name;
  final int IdPettype;

  Race(
      {this.IdPet,
      this.Name,
      this.IdPettype});

  Race.fromJson(Map<String, dynamic> json)
      : IdPet = json['id'],
        Name = json['name'],
        IdPettype = json['idpettype'];

  Map<String, dynamic> toJson() => {
        'id': IdPet,
        'name': Name,
        'idpettype': IdPettype,
      };
}