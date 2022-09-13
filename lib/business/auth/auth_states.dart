import 'package:the_store/data/models/login_model.dart';

abstract class AuthStates{}
class AuthInitial extends AuthStates{}

// register
class RegisterLoadState extends AuthStates{}
class RegisterUserState extends AuthStates{
  LoginModel loginModel;
  RegisterUserState(this.loginModel);
}
class RegisterErrorState extends AuthStates{
  String? error;
  RegisterErrorState({this.error});
}

// login
class LoginLoadState extends AuthStates{}
class LoginUserState extends AuthStates{
  LoginModel loginModel;
  LoginUserState(this.loginModel);
}
class LoginErrorState extends AuthStates{
  String? error;
  LoginErrorState({this.error});
}

//profile
class GetProfileLoad extends AuthStates{}

class GetProfileSuccess extends AuthStates{
  LoginModel? profileData;
  GetProfileSuccess(this.profileData);
}
class GetProfileError extends AuthStates{
  String? error;
  GetProfileError(this.error);
}

//update profile

class UpdateLoadState extends AuthStates{}
class UpdateSuccessState extends AuthStates{}
class UpdateErrorState extends AuthStates{}