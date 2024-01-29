import 'package:flutter/cupertino.dart';
import 'package:flutter_app/new/FoodModel.dart';
import 'package:flutter_app/new/Service.dart';

class FoodViewModel extends ChangeNotifier {
  var foodLists = <FoodModel>[];
  var cartLists = <FoodModel>[];
  var isLoading = true;

  int get countCart => cartLists.length;
  double get totalPrice => cartLists.fold(
      0,
      (previousValue, element) =>
          previousValue +
          (double.parse(element.price!.toString()) * (element.quantity ?? 0)));

  setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<void> getAllProducts() async {
    var food = await Service.fetchAllFoods();
    if (food != null) {
      foodLists = food;
      setLoading(false);
    }
  }

  addCart(FoodModel item) {
    item.quantity ??= 1;
    cartLists.add(item);
    notifyListeners();
  }

  incrementQuantity(FoodModel item) {
    item.quantity = (item.quantity ?? 0) + 1;
    notifyListeners();
  }

  decrementQuantity(FoodModel item) {
    if (item.quantity != null && item.quantity! > 1) {
      item.quantity = item.quantity! - 1;
    }
    notifyListeners();
  }

  removeCart(FoodModel item) {
    cartLists.remove(item);
    notifyListeners();
  }

  clearCart() {
    cartLists.clear();
  }
}
