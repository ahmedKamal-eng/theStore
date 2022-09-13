
abstract class StoreStates {}

class StoreInitialState extends StoreStates {}

class ShopChangeBottomNavState extends StoreStates{}
class ProductsLoad extends StoreStates{}
class ProductsDone extends StoreStates{}
class ProductAdded extends StoreStates{}
class LoadMoreProduct extends StoreStates{}

//cart
class GetCartItemsState extends StoreStates{}
class GetCartEItemsErrorState extends StoreStates{
  String error;
  GetCartEItemsErrorState( this.error);
}
class AddToCart extends StoreStates{}
class RemoveFromCart extends StoreStates{}

// payment
class MakePaymentState extends StoreStates{}

// favorite
class AddToFavoriteSuccessfully extends StoreStates{}
class AddToFavoriteError extends StoreStates{}

class RemoveFromFavoriteSuccessfully extends StoreStates{}
class RemoveFromFavoriteError extends StoreStates{}

class GetFavoritesLoad extends StoreStates{}
class GetFavoritesSuccess extends StoreStates{}
class GetFavoritesError extends StoreStates{}

//Categories

class GetCategoriesLoad extends StoreStates{}
class GetCategoriesSuccess extends StoreStates{}
class GetCategoriesError extends StoreStates{}
