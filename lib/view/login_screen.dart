import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/api/api.dart';
import 'package:shopping_cart/model/auth_model.dart';
import 'package:shopping_cart/utils/extension.dart';
import 'package:shopping_cart/view/home_screen.dart';

import '../cart/user_preference.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiController api = ApiController();
    final userName = TextEditingController();
    final password = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: userName,
              decoration: const InputDecoration(hintText: 'UserName'),
            ),
            SizedBox(
              height: context.height * 0.02,
            ),
            TextFormField(
              controller: password,
              decoration: const InputDecoration(hintText: 'password'),
            ),
            SizedBox(
              height: context.height * 0.02,
            ),
            SizedBox(
                height: 50,
                width: context.width,
                child: ElevatedButton(
                    onPressed: () {
                      api.postApi(userName.text.toString(), password.text.toString()).then((value) {
                        final userPreference = Provider.of<UserPreference>(context, listen: false);
                        userPreference.saveUserData(AuthModel(token: value.token.toString()));
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                      }).onError((error, stackTrace) {
                        if (kDebugMode) {
                          print('The error in ElevatedButton $error');
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Login')))
          ],
        ),
      ),
    );
  }
}
