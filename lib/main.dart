import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:the_store/business/app_cubit/app_cubit.dart';
import 'package:the_store/presentation/screens/Register_screen.dart';
import 'package:the_store/presentation/screens/cart_screen.dart';
import 'package:the_store/presentation/screens/home.dart';
import 'package:the_store/presentation/screens/login_screen.dart';

import 'business/app_cubit/states.dart';
import 'helpers/cache_helper.dart';
import 'helpers/dio_helper.dart';
import 'constants/constants.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey='pk_test_51LeGpjGRBERvt4UeyDDo2Y1s7ZYdXY2VDDagzRNFjnG96AGSgBrAXybihM28KpvzK25SEeaafq3WLFmWZjKtxDYO0079BQq6B6';
  DioHelper.init();
  await CacheHelper.init();


   token = CacheHelper.getData(key: 'token') ?? '';

  // bool isAuth=CacheHelper.getData(key: 'isAuth') ?? true;

  runApp( MyApp(token: token,));
}

class MyApp extends StatelessWidget {
   MyApp({Key? key,required this.token}) : super(key: key);

  String token;

  @override
  Widget build(BuildContext context) {
    return 
    
    BlocProvider(create: (context)=>StoreCubit()..getData()..getCartsProduct()..getCategories(),
      child: BlocConsumer<StoreCubit,StoreStates>(
        listener: (context,state){},
        builder: (context,state){
          return  MaterialApp(
            theme:  ThemeData(
              // primarySwatch: Color(co),
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                  titleSpacing: 20,
                  backwardsCompatibility:
                  false, //to change the status bar color & brightness
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.white,
                      statusBarIconBrightness: Brightness.dark),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  titleTextStyle: TextStyle(
                    color: Color(0xff2b475e),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  iconTheme: IconThemeData(color: Color(0xff2b475e))),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Color(0xff2b475e),
                  unselectedItemColor: Colors.grey,
                  elevation: 20,
                  backgroundColor: Colors.white),
              textTheme: TextTheme(
                bodyText1: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              fontFamily: 'Jannah',
            ),
            debugShowCheckedModeBanner: false,
            routes: {
              LoginScreen.id:(context)=>LoginScreen(),
              RegisterScreen.id:(context)=>RegisterScreen(),
              HomeScreen.id:(context)=>HomeScreen(),
              CartScreen.id:(context)=>CartScreen()
            },
            initialRoute:token == '' ? LoginScreen.id :HomeScreen.id,
          );
        },
      ),

    );
      
      

  }
}
