
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_store/business/app_cubit/app_cubit.dart';
import 'package:the_store/business/app_cubit/states.dart';
import 'package:the_store/data/models/product_model.dart';

import '../../business/auth/auth_cubit.dart';
import '../../data/models/cart_item_model.dart';

class CartScreen extends StatelessWidget {
   CartScreen({Key? key}) : super(key: key);
   static String id='cart';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit,StoreStates>(
        listener: (context,state){

        },
      builder: (context,state) {
          StoreCubit cubit=StoreCubit.get(context);
          String total=cubit.total.round().toString();

          return Scaffold(
            appBar: AppBar(title: Text('cart screen'),),
            body:  cubit.cartProducts.isEmpty?Center(child: Text('there is no product to show'),): Column(
              children: [
                Expanded(
                  child: ListView.separated(itemBuilder: (context,i){
                    return buildCartItem(cubit.cartProducts[i],context);
                  }, separatorBuilder:(context,i)=> Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(height: 1,width: double.infinity,color: Colors.teal,),
                  ) , itemCount: cubit.cartProducts.length),
                ),
                Container(height: 100,
                  color:  Colors.purpleAccent,
                  width: double.infinity,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Total Price : ${total}',style: TextStyle(fontSize: 25,color: Colors.black87),),
                      Text(' L.E',style: TextStyle(fontSize: 25,color: Colors.red.shade900,fontWeight: FontWeight.bold),)
                ,    SizedBox(width: 10,)
                      ,  ElevatedButton(

                          onPressed: (){
                      cubit.makePayment(context, total);
                      }, child: Text('pay'))
                    ],
                  ),
                )

              ],
            ),
          );







      },);
  }
}

Widget buildCartItem(CartItemModel model ,context){

  return Dismissible(
      key:UniqueKey(),
      child: Container(
          // height: 250,
          child:Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.network(model.product.image,height: 150,),
                  Column(
                    children: [
                      Container(child: Text('${model.product.name}',style: TextStyle(overflow: TextOverflow.ellipsis,),maxLines: 2,),width: 150,),
                      Text('${model.product.price}',style: TextStyle(fontSize: 20,color: Colors.red),)
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){


                  }, child: Text('+')),
                  SizedBox(width: 20,),
                  Text('1 item',style: TextStyle(fontSize: 20),),
                  SizedBox(width: 20,),

                  ElevatedButton(onPressed: (){

                  }, child: Text('-')),
                ],
              ),

            ],
          )
      ),
      onDismissed: (d){
        BlocProvider.of<StoreCubit>(context).removeFromCart(model);
      },
      background:Container(child: TextButton(
        child: Text('remove'),
        onPressed: (){

        },
      ),)
  );
}