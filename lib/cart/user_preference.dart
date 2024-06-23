import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/model/auth_model.dart';

class UserPreference extends ChangeNotifier {
  Future<bool> saveUserData(AuthModel authModel) async {
    try{
      final SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('authToken', authModel.token.toString());

      notifyListeners();
      return true;
    }
    catch(e){
      if (kDebugMode) {
        print('The e $e');
      }
      rethrow;

    }
  }

  Future<AuthModel> getUserData()async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? token = sp.getString('authToken');

    return AuthModel(
      token: token
    );
  }


  Future<bool> removeData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.clear();
  }
}
