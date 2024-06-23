import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../cart/cart_provider.dart';
import '../../model/cart_model.dart';

class CartItem extends StatelessWidget {
  final CartItems cartItem;

  const CartItem({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final data = cartItem.productModel;
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size.width * 0.30,
            height: size.height * 0.13,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Image.network(
                data.image.toString(),
                width: 70,
                height: 70,
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.005,
                ),
                Text(
                  "\$${data.price}",
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: size.width * 0.035,
                  ),
                ),
                SizedBox(
                  height: size.width * 0.030,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context
                            .read<CartProvider>()
                            .incrementQuantity(int.parse(data.id.toString()));
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black26,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    Text(
                      cartItem.quantity.toString(),
                      style: GoogleFonts.poppins(),
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<CartProvider>().decrementQuantity(int.parse(data.id.toString()));
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black26,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.black,
                          size: 14,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<CartProvider>().removeItem(int.parse(data.id.toString()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Color.fromARGB(255, 247, 247, 247),
                  content: Text(
                    "Item removed!",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.redAccent.withOpacity(0.07),
              radius: 18,
              child: const Icon(
                Icons.delete,
                color: Colors.redAccent,
                size: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
