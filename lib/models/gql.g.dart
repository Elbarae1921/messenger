// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gql.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginOutput _$LoginOutputFromJson(Map<String, dynamic> json) {
  return LoginOutput(
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    jwt: json['jwt'] as String,
  );
}

Map<String, dynamic> _$LoginOutputToJson(LoginOutput instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'jwt': instance.jwt,
    };
