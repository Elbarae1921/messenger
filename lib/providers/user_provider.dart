import 'package:flutter/foundation.dart';
import 'package:messenger/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  set user(User? user) {
    _user = user;
    notifyListeners();
  }
}
