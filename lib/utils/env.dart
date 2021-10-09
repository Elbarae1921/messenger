import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  // ignore:non_constant_identifier_names
  static String get API_URL => dotenv.env['API_URL']!;
}
