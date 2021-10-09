import 'package:json_annotation/json_annotation.dart';
import 'package:messenger/models/user.dart';

part 'gql.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class LoginOutput {
  final User user;
  final String jwt;

  LoginOutput({
    required this.user,
    required this.jwt,
  });

  factory LoginOutput.fromJson(Map<String, dynamic> json) =>
      _$LoginOutputFromJson(json);

  Map<String, dynamic> toJson() => _$LoginOutputToJson(this);
}
