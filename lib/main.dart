import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart/user_preference.dart';
import 'package:shopping_cart/view/splash_screen.dart';
import 'api/api.dart';
import 'cart/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51OHU6dAvI8Xgysh7mzPt87CvFXcrXtkqKqVKwXW1PZQFLQC68fB2Zh7gJoCubL0gixUOxUTLT5OEKJjSrBgVk2df00QrRaMTcp';
  await dotenv.load(fileName: 'assets/.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ApiController()),
        ChangeNotifierProvider(create: (_) => UserPreference())
      ],
      child: GestureDetector(
        onTap: ()=>FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(),
            appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Colors.blue,
                titleTextStyle: TextStyle(color: Colors.white)),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
