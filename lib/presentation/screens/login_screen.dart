


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:the_store/business/app_cubit/app_cubit.dart';
import 'package:the_store/business/app_cubit/states.dart';
import 'package:the_store/business/auth/auth_states.dart';

import '../../business/auth/auth_cubit.dart';
import '../../helpers/cache_helper.dart';
import '../widgets/custome_button.dart';
import '../widgets/custome_text_field.dart';
import 'Register_screen.dart';
import 'home.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);
  static String id='login';
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AuthCubit(),
      child: BlocConsumer<AuthCubit,AuthStates>(
        listener: (context,state){
          if(state is LoginUserState)
          {
            showToast('login successfully',context: context,backgroundColor: Colors.greenAccent);
            CacheHelper.saveData(key: 'token', value: state.loginModel.loginData!.token );

            Navigator.pushNamed(context, HomeScreen.id);

          }
          else if(state is LoginErrorState){
            showToast('${state.error.toString()}',context: context,duration: Duration(seconds: 3));
            print(state.error);
          }
        },
        builder: (context,state) {
          AuthCubit cubit=AuthCubit.get(context);
          return Scaffold(
            backgroundColor: Color(0xff2b475e),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Hero(
                        tag: 'i',
                        child: Image.asset(

                          'assets/images/store.png',
                          height: 150,
                        ),
                      ),
                    ),
                    Text(
                      'Store App',
                      style: TextStyle(
                          fontSize: 28, color: Colors.white, fontFamily: 'Pacifico'),
                    ),
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                     controller: emailController,
                      labelText: 'email',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                     controller: passwordController,
                      labelText: 'password',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<StoreCubit,StoreStates>(
                      builder: (context,state) {
                        return CustomButton(

                          text: "LOGIN",
                          onTap: (){

                          cubit.loginUser(emailController.text, passwordController.text);
                          StoreCubit.get(context).getData();
                          StoreCubit.get(context).getCategories();
                          StoreCubit.get(context).getCartsProduct();

                          },
                        );
                      }
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'don\'t have an account',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        TextButton(
                            onPressed: () {
                               Navigator.pushNamed(context, RegisterScreen.id);
                            },
                            child: Text('Register')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
