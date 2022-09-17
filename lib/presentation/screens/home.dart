
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_store/business/app_cubit/app_cubit.dart';
import 'package:the_store/business/app_cubit/states.dart';
import 'package:the_store/business/auth/auth_cubit.dart';
import 'package:the_store/presentation/screens/cart_screen.dart';

import '../../helpers/cache_helper.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
   static String id='home';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit,StoreStates>( listener: (context,state){},
        builder: (context,state){
        StoreCubit cubit=StoreCubit.get(context);
         return Scaffold(
           // backgroundColor: Colors.blue,
           appBar: AppBar(title: Text('home'),actions: [

             IconButton(onPressed: ()async{
               cubit.getCartsProduct();
               Navigator.pushNamed(context, CartScreen.id);
             }, icon: Stack(
               children: [
                 Icon(Icons.shopping_cart_outlined),
                 Align(
                   alignment: Alignment.bottomRight,
                   child:CircleAvatar(
                     backgroundColor: Colors.red,
                     radius: 12,
                     child: Text('${cubit.cartItemsNum.toString()}'),
                   ) ,
                 )
               ],
             )),

           ],),
           body: cubit.bottomScreens[cubit.currentIndex],
           bottomNavigationBar: BottomNavigationBar(
             currentIndex: cubit.currentIndex,
             selectedItemColor: Colors.deepOrange,
             elevation: .5,
             onTap: (index){
               cubit.changeBottom(index);
             },
             items: [
               BottomNavigationBarItem(icon: Icon(Icons.home),label: 'home'),
               BottomNavigationBarItem(icon: Icon(Icons.apps),label: 'Categories'),
               BottomNavigationBarItem(icon: Icon(Icons.favorite),label: 'Favorite'),
               BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Settings'),
             ],
           ),
         );
        }
    );


  }
}
