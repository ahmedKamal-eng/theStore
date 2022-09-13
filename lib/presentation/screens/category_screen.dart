import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_store/business/app_cubit/app_cubit.dart';
import 'package:the_store/business/app_cubit/states.dart';
import 'package:the_store/data/models/category_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int count = 20;
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<StoreCubit, StoreStates>(
        listener: (context, state) {},
        builder: (context, state) {
          StoreCubit cubit = StoreCubit.get(context);
          return Scaffold(
              body: ListView.separated(
                  itemBuilder: (context, index) {
                    return buildCategoriesItems(cubit.categories[index]) ;
                  },
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                        margin: EdgeInsets.symmetric(horizontal: 20),
                        height: 1,
                        width: double.infinity,
                        color: Colors.grey,
                      ),
                    );
                  },
                  itemCount: cubit.categories.length));
        });
  }
}

Widget buildCategoriesItems(CategoryModel model){
  return Row(

    children: [

       Image(image: NetworkImage('${model.image}'),height: 120,width: 120,),
       SizedBox(width: 20,),
       Text('${model.name}',maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 25,),)
     ],
  );
}