import 'product_model.dart';

class CartItems {
  final ProductModel productModel;
  int quantity;

  CartItems({required this.productModel, this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {
      'productModel': productModel.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItems.fromJson(Map<String, dynamic> json){
    return CartItems(
      productModel:ProductModel.fromJson(json['productModel']),
      quantity: json['quantity'],
    );

  }


}
