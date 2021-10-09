// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    id: json['id'] as String,
    content: json['content'] as String,
    image: json['image'] as String?,
    isPrivate: json['isPrivate'] as bool,
    user: json['user'],
    likers: json['likers'] as List<dynamic>,
    comments: json['comments'] as List<dynamic>,
    likes: json['likes'] as int,
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'image': instance.image,
      'isPrivate': instance.isPrivate,
      'user': instance.user,
      'likers': instance.likers,
      'comments': instance.comments,
      'likes': instance.likes,
    };
