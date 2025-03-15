import 'dart:convert';
import 'package:flutter_top_receit/config/router/api_config.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class FollowDataSource {
  Future<List<UserModel>> getFollowers(String userId);
  Future<List<UserModel>> getFollowing(String userId);
  Future<bool> followUser(String followerId, String followedId);
  Future<bool> unfollowUser(String followerId, String followedId);
}

class FollowApiDataSource implements FollowDataSource {
  final String baseUrl = ApiConfig.baseUrl;
  final http.Client client;

  FollowApiDataSource(this.client);

  @override
  Future<List<UserModel>> getFollowers(String userId) async {
    final url = Uri.parse('$baseUrl/follows/$userId/followers');

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw ServerFailure(message: 'Error al obtener la lista de seguidores');
    }
  }

  @override
  Future<List<UserModel>> getFollowing(String userId) async {
    final url = Uri.parse('$baseUrl/follows/$userId/following');

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw ServerFailure(message: 'Error al obtener la lista de siguiendo');
    }
  }

  @override
  Future<bool> followUser(String followerId, String followedId) async {
    final url = Uri.parse('$baseUrl/follows/$followerId/follow/$followedId');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return true; // El usuario ha sido seguido con éxito
    } else {
      throw ServerFailure(message: 'Error al seguir al usuario');
    }
  }

  @override
  Future<bool> unfollowUser(String followerId, String followedId) async {
    final url = Uri.parse('$baseUrl/follows/$followerId/unfollow/$followedId');

    final response = await client.delete(url);

    if (response.statusCode == 200) {
      return true; // El usuario ha sido dejado de seguir con éxito
    } else {
      throw ServerFailure(message: 'Error al dejar de seguir al usuario');
    }
  }
}
