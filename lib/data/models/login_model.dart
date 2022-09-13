class LoginModel {
  late bool status;
   String? message;
   LoginData? loginData;
  LoginModel(this.status, this.message, this.loginData);
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(json["status"], json['message'], LoginData.fromJson(json['data']));
  }
}

class LoginData {
  late String name;
  late String email;
  late String phone;
  late String image;
  late String token;

  LoginData(this.name, this.email, this.phone, this.image, this.token);

  factory LoginData.fromJson(json) {
    return LoginData(json['name'], json['email'], json['phone'], json['image'],
        json['token']);
  }
}
