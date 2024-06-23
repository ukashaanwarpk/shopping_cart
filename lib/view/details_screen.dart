
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/utils/extension.dart';

import '../cart/cart_provider.dart';
import '../model/product_model.dart';
import 'cart_details.dart';

class DetailsScreen extends StatelessWidget {
  final ProductModel productModel;
  const DetailsScreen({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Screen'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          CachedNetworkImage(imageUrl: productModel.image.toString(), height: context.height*0.40, width: context.width, fit: BoxFit.cover,),
          Container(
            padding: const EdgeInsets.all(15),
            margin: EdgeInsets.only(top: context.height*0.25),
            decoration: const BoxDecoration(
              color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(productModel.title.toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.height*0.02,),
                Text(productModel.description.toString(), maxLines: 7, overflow: TextOverflow.ellipsis,),
                SizedBox(height: context.height*0.03,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Price : \$${productModel.price}',style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700),),
                    SizedBox(
                      width: context.width*0.20,
                      child: ElevatedButton(onPressed: (){
                        provider.addToCart(productModel, 1);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Color.fromARGB(255, 247, 247, 247),
                            content: Text(
                              "Item Added!",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                          child: const Text('Add to cart', style: TextStyle(fontWeight: FontWeight.w700),)),
                    ),
                  ],
                ),
                SizedBox(height: context.height*0.04,),
                const Spacer(),
                SizedBox(
                  height: 50,
                  width: context.width,
                  child: ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const CartDetails()));
                  },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.w700),)),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
