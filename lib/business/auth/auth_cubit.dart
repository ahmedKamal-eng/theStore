import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_store/data/models/login_model.dart';

import '../../constants/constants.dart';
import '../../data/models/profile_model.dart';
import '../../helpers/dio_helper.dart';
import '../app_cubit/states.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);
  //________________________
  // Register    ___________
  //________________________
  LoginModel? loginModel;
  void registerUser(
      {required String name,
      required String email,
      required String password,
      required String phone})async {
        emit(RegisterLoadState());
       DioHelper.postData(url: 'register', data: {
         'name':name,
         'email':email,
         'password':password,
         'phone':phone
       }).then((value) {
         loginModel=LoginModel.fromJson(value.data);
         emit(RegisterUserState(loginModel!));
         print(loginModel!.loginData!.token);
       }).catchError((e){

         emit(RegisterErrorState(error: e.toString()));
       });
  }

   //+++++++++++++
   //login
   //+++++++++++++
void loginUser(String email,String password)async{
   emit(LoginLoadState());
    DioHelper.postData(url: 'login', data: {'email':email,
    'password':password
    }).then((value) {
       loginModel=LoginModel.fromJson(value.data);
       emit(LoginUserState(loginModel!));

    }).catchError((e){
      emit(LoginErrorState(error: e.toString()));
    });

}

//++++++++++ Profile

LoginModel? profileModel;
  
  Future<void> getProfile()async{
    emit(GetProfileLoad());
    DioHelper.getData(url: 'profile',token: token).then((value) {
      profileModel=LoginModel.fromJson(value.data);
      emit(GetProfileSuccess(profileModel));
    }).catchError((e){
      print(e.toString());
      emit(GetProfileError(e.toString()));
    });
    
  }

  //Update
 Future<void> updateProfile({String? name,String? phone,String? email})async{
   emit(UpdateLoadState());
   DioHelper.putData(url: 'update-profile', data: {'name':name,'phone':phone,'email':email},token: token).then((value) {
     loginModel=LoginModel.fromJson(value.data);
     emit(UpdateSuccessState());
  }).catchError((e){
    print(e.toString());
    emit(UpdateErrorState());
  });
 }
  
  
}
