// import 'dart:js';



import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:the_store/business/app_cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:the_store/data/models/cart_item_model.dart';
import 'package:the_store/data/models/category_model.dart';
import 'package:the_store/data/models/favorite_model.dart';
import 'package:the_store/data/models/product_model.dart';
import 'package:the_store/helpers/dio_helper.dart';
import '../../constants/constants.dart';
import '../../presentation/screens/category_screen.dart';
import '../../presentation/screens/favorite_screen.dart';
import '../../presentation/screens/product_screen.dart';
import '../../presentation/screens/settings.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StoreCubit extends Cubit<StoreStates> {
  StoreCubit() : super(StoreInitialState());
  static StoreCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoryScreen(),
    FavoriteScreen(),
    SettingsScreen(),
  ];
  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  // get products

  List<ProductModel> products = [];
  bool isLoad = true;
  int itemCount = 5;

  void addItems() async{
    if(itemCount<products.length) emit(LoadMoreProduct());

      await Future.delayed(Duration(seconds: 1));
    if ((products.length - 3) > itemCount)
      itemCount += 2;
    else {
      itemCount = products.length;
    }
    emit(ProductAdded());
  }

  void getData() {
    emit(ProductsLoad());
    DioHelper.getData(url: 'home', token: token).then((value) {
      List banners = value.data["data"]["products"];
      for (int i = 0; i < banners.length; i++) {
        products.add(ProductModel.fromJson(banners[i]));

      }
      print(token);
      emit(ProductsDone());
    });
  }


  //Cart
 List<CartItemModel> cartProducts=[];
  int cartItemsNum=0;
   dynamic total;

  void getCartsProduct() async{
    DioHelper.getData(url: 'carts',token: token).then((value) {
            List<dynamic> items=value.data['data']["cart_items"];
            cartProducts=[];
          for(int i=0;i<items.length;i++)
            {
              cartProducts.add(CartItemModel.fromJson(items[i]));
            }
            total=value.data['data']["total"];
              cartItemsNum=cartProducts.length;
            emit(GetCartItemsState());

    }).catchError((e){
      print(e.toString());
      emit(GetCartEItemsErrorState(e.toString()));
    });
}

  void removeFromCart(CartItemModel productModel) async
  {
    // productModel.inCart=false;
    // cartProducts.remove(productModel);
    // emit(RemoveFromCart());

    DioHelper.postData(url:'carts', data: {"product_id":productModel.product.id},token: token).then((value) {
      print(value.data['message']);
      cartProducts.remove(productModel);
      cartItemsNum= cartProducts.length;
      total= total-productModel.product.price;
      for(int i=0;i<products.length;i++){
        if(products[i].id==productModel.product.id)
          {
            products[i].inCart=false;
          }
      }

      emit(RemoveFromCart());

    }).catchError((e){
      print(e.toString());
    });
  }

  void addToCart(ProductModel productModel) async
  {
    productModel.inCart=true;

    DioHelper.postData(url:'carts', data: {"product_id":productModel.id},token: token).then((value) {
     print(value.data['message']);


     cartItemsNum++;


     emit(AddToCart());

   }).catchError((e){
     print(e.toString());
   });

  }


  /*_____________
  *Favorite Section
__________________*/


  Future<void> addToFavorite(ProductModel model)async{
    DioHelper.postData(url: 'favorites', data: {'product_id':model.id},token: token).then((value) {
       model.inFavorites=true;

      emit(AddToFavoriteSuccessfully());
    }).catchError((e){
      print(e.toString());
      emit(AddToFavoriteError());
    });
  }

  Future<void> removeFromFavorite(ProductModel model)async{
    DioHelper.postData(url: 'favorites', data: {'product_id':model.id},token: token).then((value) {
      model.inFavorites=false;
      emit(RemoveFromFavoriteSuccessfully());
    }).catchError((e){
      print(e.toString());
      emit(RemoveFromFavoriteError());
    });
  }

   List<FavoriteModel> favoriteItems=[];

   Future<void> getFavoritesItems()async{
     favoriteItems=[];

     emit(GetFavoritesLoad());
     DioHelper.getData(url: 'favorites',token: token).then((value) {
         List<dynamic> items=value.data['data']['data'];
         for(int i=0;i<items.length;i++)
           {
             favoriteItems.add(FavoriteModel.fromJson(items[i]));
           }
         emit(GetFavoritesSuccess());

     }).catchError((e){
       print(e.toString());
       emit(GetFavoritesError());
     });

   }


  //Categories
  List<CategoryModel> categories=[];
   Future<void> getCategories()async{

     emit(GetCategoriesLoad());
     DioHelper.getData(url: 'categories').then((value) {
       categories=[];
       List<dynamic> items=value.data['data']['data'];
       for(int i=0;i<items.length;i++) {
         categories.add( CategoryModel.fromJson(items[i]));
       }
       emit(GetCategoriesSuccess());
     }).catchError((e){
       print(e.toString());
       emit(GetCategoriesError());
     });
   }

  // double getTotal(){
  //   double total=0;
  //   for(int i=0;i<cartProducts.length;i++)
  //     {
  //       total += cartProducts[i].price;
  //     }
  //   return total;
  // }



// payment
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(context,dynamic total) async {
    try {
      paymentIntent = await createPaymentIntent('${total}', 'USD');
      //Payment Sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
              // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
              style: ThemeMode.dark,
              merchantDisplayName: 'Adnan')).then((value){
      });


      ///now finally display payment sheeet
      displayPaymentSheet(context);
      emit(MakePaymentState());
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(context) async {

    try {
      await Stripe.instance.presentPaymentSheet(
      ).then((value){
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green,),
                      Text("Payment Successfull"),
                    ],
                  ),
                ],
              ),
            ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;

      }).onError((error, stackTrace){
        print('Error is:--->$error $stackTrace');
      });


    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_51LeGpjGRBERvt4UeswIgK0uDvrDprR1ooGdxrMXXCKX3z5BB0ukXKgXvauErmdskcw6T8p0uDmCU98BLEVgcfy1A00aIBcDN39',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100 ;
    return calculatedAmout.toString();
  }

  //
  // displayPaymentSheet(context) async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet();
  //     // Get.snackbar('Payment', 'Payment Successful',
  //     //     snackPosition: SnackPosition.BOTTOM,
  //     //     backgroundColor: Colors.green,
  //     //     colorText: Colors.white,
  //     //     margin: const EdgeInsets.all(10),
  //     //     duration: const Duration(seconds: 2));
  //     showToast('login successfully',context: context,backgroundColor: Colors.greenAccent);
  //
  //   } on Exception catch (e) {
  //     if (e is StripeException) {
  //       print("Error from Stripe: ${e.error.localizedMessage}");
  //     } else {
  //       print("Unforeseen error: ${e}");
  //     }
  //   } catch (e) {
  //     print("exception:$e");
  //   }
  // }
  //
  // //  Future<Map<String, dynamic>>
  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //       'payment_method_types[]': 'card'
  //     };
  //     var response = await http.post(
  //         Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //         body: body,
  //         headers: {
  //           'Authorization': 'Bearer Your Stripe Secret Key',
  //           'Content-Type': 'application/x-www-form-urlencoded'
  //         });
  //     return jsonDecode(response.body);
  //   } catch (err) {
  //     print('err charging user: ${err.toString()}');
  //   }
  // }
  //
  // calculateAmount(String amount) {
  //   final a = (int.parse(amount)) * 100;
  //   return a.toString();
  // }

}









