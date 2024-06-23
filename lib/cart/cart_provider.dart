import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/cart_model.dart';
import '../model/product_model.dart';

class CartProvider extends ChangeNotifier {
  CartProvider() {
    loadCartItems();
  }

  final List<CartItems> _cartItems = [];

  List<CartItems> get cartItems => _cartItems;

  final Map<int, bool> _isLoadingMap = {}; //

  bool isLoading(int productId) {
    return _isLoadingMap[productId] ?? false;
  }

  void setLoading(int productId, bool value) {
    _isLoadingMap[productId] = value;
    notifyListeners();
  }

  void addToCart(ProductModel productModel, int quantity) {
    final productId = productModel.id;
    setLoading(productId!, true);

    var isExist =
        _cartItems.where((item) => item.productModel.id == productModel.id);

    if (isExist.isEmpty) {
      _cartItems.add(CartItems(productModel: productModel, quantity: quantity));
    } else {
      isExist.first.quantity += quantity;
    }
    Future.delayed(
      const Duration(milliseconds: 2000),
      () {
        setLoading(productId, false);
        notifyListeners();
      },
    );
    saveCartItems();

    notifyListeners();
  }

  void removeItem(int productId) {
    _cartItems.removeWhere((element) => element.productModel.id == productId);
    saveCartItems();
    notifyListeners();
  }

  void incrementQuantity(int productId) {
    CartItems item = _cartItems
        .where((element) => element.productModel.id == productId)
        .first;
    item.quantity++;
    saveCartItems();
    notifyListeners();
  }

  void decrementQuantity(int productId) {
    CartItems item = _cartItems
        .where((element) => element.productModel.id == productId)
        .first;
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _cartItems.remove(item);
    }
    saveCartItems();
    notifyListeners();
  }

  void clearCart(){
    _cartItems.clear();
    saveCartItems();
    notifyListeners();
  }

  double getCartTotal() {
    double total = 0;
    for (var cartItem in _cartItems) {
      total += (cartItem.productModel.price! * cartItem.quantity);
    }
    return total;
  }

  int get cartCount => _cartItems.fold(
      0, (previousValue, element) => previousValue + element.quantity);

  double get cartSubTotal => getCartTotal();

  double get shippingCharge => 120;

  double get cartTotal => cartSubTotal + shippingCharge;

  Future<void> saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson =
        jsonEncode(_cartItems.map((item) => item.toJson()).toList());
    await prefs.setString('cart_items', cartItemsJson);
  }

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson = prefs.getString('cart_items');
    if (cartItemsJson != null) {
      List<dynamic> cartItemsList = jsonDecode(cartItemsJson);
      _cartItems.addAll(cartItemsList
          .map((itemJson) => CartItems.fromJson(itemJson))
          .toList());
    }
  }


}
