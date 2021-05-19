class UserRegister {
  final int IdUser;
  final String Email;
  final bool Terms;

  UserRegister(
      {this.IdUser,
      this.Email,
      this.Terms});

  UserRegister.fromJson(Map<dynamic, dynamic> json)
      : IdUser = json['id'],
        Email = json['email'],
        Terms = json['terms'];

  Map<String, dynamic> toJson() => {
        'id': IdUser,
        'email': Email,
        'terms': Terms,
      };
}