import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
