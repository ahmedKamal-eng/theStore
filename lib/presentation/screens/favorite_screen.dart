import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_store/business/app_cubit/app_cubit.dart';
import 'package:the_store/data/models/favorite_model.dart';

import '../../business/app_cubit/states.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<StoreCubit>(context).getFavoritesItems();
    return BlocConsumer<StoreCubit, StoreStates>(
        listener: (context, state) {},
        builder: (context, state) {
          StoreCubit cubit = StoreCubit.get(context);
          return state is GetFavoritesLoad
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                )
              : ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buildFavoriteItem(cubit.favoriteItems[index],context);
                  },
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        color: Colors.teal,
                        width: double.infinity,
                        height: 2,
                      ),
                    );
                  },
                  itemCount: cubit.favoriteItems.length);
        });
  }
}

Widget buildFavoriteItem(FavoriteModel model,context) {
  return Container(
      height: 120,
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            child: FadeInImage(
              image: NetworkImage('${model.product!.image}'),
              placeholder: AssetImage('assets/images/store.png'),
              height: 120,
              width: 120,
            ),
            width: 140,
          ),
          SizedBox(
            width: 40,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.product!.name}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(),
                ),
                Text(
                  '${model.product!.price}',
                  style: TextStyle(color: Colors.blue),
                )
              ],
            ),
          )
        ],
      ));
}
