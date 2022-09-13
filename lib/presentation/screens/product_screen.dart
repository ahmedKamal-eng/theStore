
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:paginable/paginable.dart';
import 'package:the_store/business/app_cubit/app_cubit.dart';
import 'package:the_store/business/app_cubit/states.dart';
import 'package:the_store/data/models/product_model.dart';

class ProductsScreen extends StatelessWidget {
  // bool isLoad=true;
   ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit,StoreStates>(builder: (context,state){
      StoreCubit cubit=StoreCubit.get(context);
      return cubit.isLoad ?Center(child: CircularProgressIndicator(),): Container(
          child: Column(
            children: [
              Expanded(
                child: PaginableListView.builder(
                   shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    loadMore: () async {
                      cubit.addItems();
                    },
                    errorIndicatorWidget: (exception, tryAgain) => Container(
                      color: Colors.redAccent,
                      height: 130,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            exception.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                            ),
                            onPressed: tryAgain,
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                    progressIndicatorWidget: const SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    itemBuilder:(context,index){
                     return buildProductItem(cubit.products[index],(){
                       cubit.addToCart(cubit.products[index]);
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(duration: Duration(seconds: 1),backgroundColor: Color(0xff005500),content:  Text('item added successfully')));
                     },(){
                       if(cubit.products[index].inFavorites == true)
                       {
                           cubit.removeFromFavorite(cubit.products[index]);
                         }else{
                         cubit.addToFavorite(cubit.products[index]);
                       }
                     });
                    },
                    itemCount:cubit.itemCount),
              ),
             if(state is LoadMoreProduct)
               Container(height: 70,child: Center(child: CircularProgressIndicator(),),)

            ],
          ),
      );
    }, listener: (context,state){
      if(state is ProductsDone)
        {
          StoreCubit.get(context).isLoad=false;
        }else if(state is ProductsLoad){
       StoreCubit.get(context).isLoad=true;
      }

      if(state is AddToFavoriteSuccessfully){
        showToast('product added to favorite successfully',backgroundColor: Colors.greenAccent,context: context);
      }

      if(state is RemoveFromFavoriteSuccessfully)
        showToast('product remove from favorite successfully',backgroundColor: Colors.redAccent,context: context);


    });
  }
}


Widget buildProductItem(ProductModel model,Function() onTap,Function() pressFavorite){
  return Card(
    margin: EdgeInsets.all(10),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Image.network('${model.image}',height: 200,),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('${model.name}'),
          ),
          Text('${model.price}',style: TextStyle(fontSize: 22,color: Colors.teal.shade700),),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed:model.inCart! ?null:onTap, child: Text('add to cart',style: TextStyle(fontSize: 22),)),
              IconButton(onPressed: pressFavorite
              , icon:Icon( Icons.favorite,color: model.inFavorites==true ?Colors.redAccent:Colors.grey, size: 40,))
            ],
          )
        ],
      ),
    ),
  );
}
