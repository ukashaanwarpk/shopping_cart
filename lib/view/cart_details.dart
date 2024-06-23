import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/api/stripe.dart';

import '../cart/cart_provider.dart';
import 'widget/cart_list_item.dart';


class CartDetails extends StatefulWidget {
  const CartDetails({super.key});

  @override
  State<CartDetails> createState() => _CartDetailsState();
}

class _CartDetailsState extends State<CartDetails> {

  StripeController stripeController = StripeController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Details",
          style: GoogleFonts.poppins(
            fontSize: size.width * 0.040,
            fontWeight: FontWeight.w600,
          ),

        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: SizedBox(
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: context.watch<CartProvider>().cartItems.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My Cart",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Consumer<CartProvider>(
                              builder: (context, value, child) => Column(
                                children: value.cartItems
                                    .map(
                                      (cartItem) => CartItem(
                                        cartItem: cartItem,
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: size.height * 0.25,
                              ),
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: size.width * 0.20,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: size.height * 0.020,
                              ),
                              Text(
                                "Your cart is empty!",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.020,
            ),
            SizedBox(
                child: context.watch<CartProvider>().cartItems.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order Info",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: size.width * 0.040,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.010,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Sub Total",

                              ),
                              Text(
                                "\$${context.watch<CartProvider>().cartSubTotal.toStringAsFixed(2)}",

                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.008,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Shipping",

                              ),
                              Text(
                                "+\$${context.watch<CartProvider>().shippingCharge}",

                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "\$${context.watch<CartProvider>().cartTotal.toStringAsFixed(2)}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.030,
                          ),
                          SizedBox(
                            width: size.width,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async{
                              await stripeController.makePayment(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Checkout (\$${context.watch<CartProvider>().cartTotal.toStringAsFixed(2)})",
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : Container())
          ],
        ),
      ),
    );
  }
}
