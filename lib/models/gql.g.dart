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

GetPostsOutput _$GetPostsOutputFromJson(Map<String, dynamic> json) {
  return GetPostsOutput(
    results: (json['results'] as List<dynamic>)
        .map((e) => Post.fromJson(e as Map<String, dynamic>))
        .toList(),
    hasMore: json['hasMore'] as bool,
    lastId: json['lastId'] as int?,
  );
}

Map<String, dynamic> _$GetPostsOutputToJson(GetPostsOutput instance) =>
    <String, dynamic>{
      'results': instance.results.map((e) => e.toJson()).toList(),
      'hasMore': instance.hasMore,
      'lastId': instance.lastId,
    };
