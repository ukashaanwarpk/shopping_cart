import 'dart:convert';
import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shopping_cart/view/home_screen.dart';
import '../cart/cart_provider.dart';

class StripeController {
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(BuildContext context) async {
    try {
      paymentIntentData = await createPaymentIntent(
          '${Provider.of<CartProvider>(context, listen: false).cartTotal}',
          'USD');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              merchantDisplayName: "ukasha",
              googlePay: const PaymentSheetGooglePay(
                merchantCountryCode: 'US',
              )));
      if (context.mounted) {
        displayPaymentSheet(context);
      }
    } catch (e) {
      log("Error in making payment $e");
    }
  }

  displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();

      paymentIntentData = null;

      if (context.mounted) {
        Provider.of<CartProvider>(context, listen: false).clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Paid Successfully"),
          ),
        );
        AwesomeDialog(
          context: context,
          title: 'Success',
          dialogType: DialogType.success,
          desc: 'Your item will be shipped soon!',
          btnOkText: 'Continue Shopping',
          btnOkColor: Colors.blue,
          btnOkOnPress: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        ).show();
      }
    } on StripeException catch (e) {
      log("Exception $e");
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  content: Text("Cancelled"),
                ));
      }
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body.toString());
    } catch (e) {
      log("Exception $e");
    }
  }

  String calculateAmount(String amount) {
    final doubleAmount = double.parse(amount);
    //  multiply by 100 to convert dollars to cents
    final price = (doubleAmount * 100).toInt();
    return price.toString();
  }
}
