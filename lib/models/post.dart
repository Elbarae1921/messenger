import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class Post {
  final String id;
  final String content;
  final String? image;
  final bool isPrivate;
  final dynamic user;
  final List<dynamic> likers;
  final List<dynamic> comments;
  final int likes;

  Post({
    required this.id,
    required this.content,
    required this.image,
    required this.isPrivate,
    required this.user,
    required this.likers,
    required this.comments,
    required this.likes,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
