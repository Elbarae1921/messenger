import 'package:flutter/cupertino.dart';

enum Asset { defaultUser }

class Assets {
  static AssetImage get(Asset asset) {
    switch (asset) {
      case Asset.defaultUser:
      default:
        return AssetImage('assets/images/default.png');
    }
  }
}
