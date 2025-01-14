import 'dart:convert';
import 'package:flutter_top_receit/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_top_receit/core/failure.dart';

abstract class UserDataSource {
  Future<UserModel> createUser(String email, String username, String avatar,
      List<String> preferences, String id);
  Future<UserModel> getUser(String userId);
  Future<UserModel> updateUser(UserModel user);
}

class UserApiDataSource implements UserDataSource {
  final String baseUrl = 'http://localhost:3000';
  final http.Client client;

  UserApiDataSource(this.client);

  @override
  Future<UserModel> createUser(String email, String username, String avatar,
      List<String> preferences, String id) async {
    final url = Uri.parse('$baseUrl/users');

    final userMap = {
      'id_user': id,
      'email': email,
      'username': username,
      'avatar': avatar,
      'preferences': preferences,
      'role': 2,
    };

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userMap),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return UserModel.fromJson(responseData);
    } else {
      throw ServerFailure(message: 'Error al crear el usuario en NestJS');
    }
  }

  @override
  Future<UserModel> getUser(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return UserModel.fromJson(responseData);
    } else {
      throw ServerFailure(message: 'Error al obtener los datos del usuario');
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    final url = Uri.parse('$baseUrl/users/${user.id}');

    final response = await client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': user.username,
        'avatar': user.avatar,
        'preferences': user.preferences,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return UserModel.fromJson(responseData);
    } else {
      throw ServerFailure(message: 'Error al actualizar el usuario en NestJS');
    }
  }
}
