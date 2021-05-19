
class PetType {
  final int IdPet;
  final String Name;
  

  PetType(
      {this.IdPet,
      this.Name});

  PetType.fromJson(Map<String, dynamic> json)
      : IdPet = json['id'],
        Name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': IdPet,
        'name': Name,
      };

  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //       IdUser: json['IdUser'],
  //       LastName: json['LastName'],
  //       FirstName: json['FirstName'],
  //       Address: json['Address'],
  //       Email: json['Email'],
  //       Telephone: json['Telephone'],
  //       IdPet: json['IdPet']);
  // }
}
