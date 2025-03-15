import 'package:flutter_top_receit/data/models/user_model.dart';

class FollowModel {
  final String id;
  final UserModel follower;
  final UserModel followed;

  FollowModel({
    required this.id,
    required this.follower,
    required this.followed,
  });

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    return FollowModel(
      id: json['id'] ?? '',
      follower: UserModel.fromJson(json['follower']),
      followed: UserModel.fromJson(json['followed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'follower': follower.toJson(),
      'followed': followed.toJson(),
    };
  }
}
