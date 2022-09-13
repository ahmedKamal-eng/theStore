import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:the_store/business/auth/auth_cubit.dart';
import 'package:the_store/business/auth/auth_states.dart';
import 'package:the_store/presentation/screens/login_screen.dart';

import '../../helpers/cache_helper.dart';
import '../widgets/custome_button.dart';

class SettingsScreen extends StatelessWidget {
   SettingsScreen({Key? key}) : super(key: key);

   TextEditingController nameController=TextEditingController();
   TextEditingController emailController=TextEditingController();
   TextEditingController phoneController=TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context)=>AuthCubit()..getProfile(),
      child: BlocConsumer<AuthCubit,AuthStates>(
        listener: (context,state){
          if(state is GetProfileSuccess) {
            nameController.text = state.profileData!.loginData!.name;
            emailController.text = state.profileData!.loginData!.email;
            phoneController.text = state.profileData!.loginData!.phone;
          }

          if(state is UpdateSuccessState){
            showToast('update data successfully',context: context,backgroundColor: Colors.greenAccent);
          }
        },
        builder: (context,state) {

          AuthCubit cubit=AuthCubit.get(context);

          return state is GetProfileLoad ? const Center(child: CircularProgressIndicator(),): Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                   controller: nameController,
                    validator: (d){
                     if(d!.isEmpty)
                       {
                         return 'field is empty';
                       }

                    },
                    decoration: InputDecoration(
                      label: Text('name'),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person)
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                   controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (d){
                     if(d!.isEmpty)
                       {
                         return 'field is empty';
                       }

                    },
                    decoration: InputDecoration(
                      label: Text('email'),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email)
                    ),
                  ),
                  SizedBox(height: 20,),

                  TextFormField(
                   controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (d){
                     if(d!.isEmpty)
                       {
                         return 'field is empty';
                       }

                    },
                    decoration: InputDecoration(
                      label: Text('phone'),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone)
                    ),
                  ),
                  SizedBox(height: 20,),
                  CustomButton(text: 'Update',color: Colors.blue,textColor: Colors.white,onTap: (){
                    cubit.updateProfile(name: nameController.text,email: emailController.text,phone: phoneController.text);
                  },),
                  state is UpdateLoadState ? LinearProgressIndicator():Container(),
                  SizedBox(height: 20,),
                  CustomButton(text: 'LogOut',color: Colors.blue,textColor: Colors.white,onTap: (){
                    CacheHelper.saveData(key: 'token', value: '' );
                    Navigator.pushNamed(context, LoginScreen.id);

                  },)
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
