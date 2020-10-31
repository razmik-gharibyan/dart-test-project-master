import 'package:data_model/data_model.dart';

class User implements Model<UserId> {
  UserId id;
  String name;
  String password;
  String email;
  String phone;
  User({this.id, this.name, this.password,this.email,this.phone});
  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return User(
        id: UserId(json['id']), name: json['name'], password: json['password'],
        email: json['email'], phone: json['phone']);
  }

  Map<String, dynamic> get json => {
        'id': id?.json,
        'name': name,
        'password': password,
        'email': email,
        'phone': phone
      }..removeWhere((key, value) => value == null);
}

class UserId extends ObjectId {
  UserId._(id) : super(id);
  factory UserId(id) {
    if (id == null) return null;
    return UserId._(id);
  }
}
