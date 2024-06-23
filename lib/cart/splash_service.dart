import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shopping_cart/cart/user_preference.dart';
import 'package:shopping_cart/view/home_screen.dart';
import 'package:shopping_cart/view/login_screen.dart';

import '../model/auth_model.dart';

class SplashService{

 Future<AuthModel> getData()=>UserPreference().getUserData();


 void isLogin(BuildContext context)async{
   getData().then((value){
     if (kDebugMode) {
       print('The value ${value.token}');
     }
     if(value.token == null || value.token==''){
       Future.delayed(const Duration(seconds: 3), (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
       });
     }
     else{
       Future.delayed(const Duration(seconds: 3), (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
       });
     }

   }).onError((error, stackTrace) {

     if (kDebugMode) {
       print('The Error in isLogin $error');
     }

   });
 }

}