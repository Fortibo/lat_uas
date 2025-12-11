import 'package:flutter/material.dart';
import 'package:lat_uas/models/user.dart';

class UserLog extends ChangeNotifier {
  List<User> users = [];
  void login(User newUser) {
    users.add(newUser);
    notifyListeners();
  }
}
