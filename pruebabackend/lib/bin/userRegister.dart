class UserRegister {
  final String IdUser;
  final String Email;
  final String Terms;
  final String dateRegister;

  UserRegister({this.IdUser, this.Email, this.Terms, this.dateRegister});

  UserRegister.fromJson(Map<dynamic, dynamic> json)
      : IdUser = json['id'],
        Email = json['email'],
        Terms = json['terms'],
        dateRegister = json['dateRegister'];

  Map<String, dynamic> toJson() => {
        'id': IdUser,
        'email': Email,
        'terms': Terms,
        'dateRegister': dateRegister
      };
}
