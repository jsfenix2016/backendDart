
class User {
  final int IdUser;
  final String LastName;
  final String FirstName;
  final String Address;
  final String Email;
  final String Telephone;
  final int IdPet;
  final String Pass;
  final String Image_1;

  User(
      {this.IdUser,
      this.LastName,
      this.FirstName,
      this.Address,
      this.Email,
      this.Telephone,
      this.IdPet, 
      this.Pass, 
      this.Image_1});

  User.fromJson(Map<String, dynamic> json)
      : IdUser = json['id'],
        LastName = json['LastName'],
        FirstName = json['FirstName'],
        Address = json['Address'],
        Email = json['email'],
        Telephone = json['Telephone'],
        IdPet = json['IdPet'],
        Pass = json['pass'],
        Image_1 = json['image_1'];

  Map<String, dynamic> toJson() => {
        'id': IdUser,
        'LastName': LastName,
        'FirstName': FirstName,
        'Address': Address,
        'email': Email,
        'Telephone': Telephone,
        'IdPet': IdPet,
        'pass': Pass,
        'image_1': Image_1
      };

}
