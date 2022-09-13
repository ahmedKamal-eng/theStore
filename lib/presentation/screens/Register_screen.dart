import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:the_store/business/auth/auth_cubit.dart';
import 'package:the_store/business/auth/auth_states.dart';
import 'package:the_store/presentation/screens/home.dart';

import '../../helpers/cache_helper.dart';
import '../widgets/custome_button.dart';
import '../widgets/custome_text_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  static String id = 'register';
  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            // if(state is RegisterLoadState)
            //   {
            //     showDialog(context: context, builder: (context){
            //       return AlertDialog(
            //         backgroundColor: Colors.white.withOpacity(.5),
            //         content: Center(child: CircularProgressIndicator(),),
            //         elevation: 0,
            //       );
            //     },
            //       barrierColor: Colors.white.withOpacity(0),
            //
            //       barrierDismissible: false,
            //     );
            //   }
            if(state is RegisterUserState)
              {
                showToast('register successfully',context: context,backgroundColor: Colors.greenAccent);
                CacheHelper.saveData(key: 'token', value: state.loginModel.loginData!.token );
                Navigator.pushNamed(context, HomeScreen.id);

              }
           else if(state is RegisterErrorState){
             showToast('${state.error.toString()}',context: context,duration: Duration(seconds: 3));
              print(state.error);
           }
          },
          builder: (context, state) {
            AuthCubit cubit = AuthCubit.get(context);
            return Scaffold(
              backgroundColor: Color(0xff2b475e),
              body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
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
                              height: 90,
                            ),
                          ),
                        ),
                        Text(
                          'Store App',
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontFamily: 'Pacifico'),
                        ),
                        const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          textInputType: TextInputType.name,
                          controller: nameController,
                          labelText: 'name',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          controller: emailController,
                          textInputType: TextInputType.emailAddress,
                          labelText: 'email',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          controller: passwordController,
                          textInputType: TextInputType.visiblePassword,
                          labelText: 'password',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          controller: phoneController,
                          textInputType: TextInputType.phone,
                          labelText: 'phone',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          text: "Register",
                          onTap: () {
                            cubit.registerUser(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                phone: phoneController.text);

                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'don\'t have an account',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Login')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
