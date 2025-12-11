import 'package:flutter/material.dart';
import 'package:lat_uas/models/user.dart';

class CurrentUser extends ChangeNotifier {
  late User? user;
  CurrentUser({this.user}) {
    user ??= User();
  }

  void changeCurrentUser(User newuser) {
    user = newuser;
    notifyListeners();
  }
}
