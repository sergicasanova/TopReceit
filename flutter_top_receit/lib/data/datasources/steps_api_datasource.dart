import 'dart:convert';
import 'package:flutter_top_receit/config/router/api_config.dart';
import 'package:flutter_top_receit/data/models/step_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_top_receit/core/failure.dart';

abstract class StepsDataSource {
  Future<List<StepModel>> getStepsByRecipe(int recipeId);
  Future<StepModel> createStep(int recipeId, StepModel step);
  Future<StepModel> updateStep(int stepId, StepModel step);
  Future<void> deleteStep(int recipeId, int stepId);
  Future<void> deleteStepById(int stepId);
}

class StepsApiDataSource implements StepsDataSource {
  final String baseUrl = ApiConfig.baseUrl;
  final http.Client client;

  StepsApiDataSource(this.client);

  @override
  Future<List<StepModel>> getStepsByRecipe(int recipeId) async {
    final url = Uri.parse('$baseUrl/steps/$recipeId');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => StepModel.fromJson(data)).toList();
    } else {
      throw ServerFailure(message: 'Error al obtener los pasos de la receta.');
    }
  }

  @override
  Future<StepModel> createStep(int recipeId, StepModel step) async {
    final url = Uri.parse('$baseUrl/steps/$recipeId');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'description': step.description,
        'order': step.order,
        'recipe_id': recipeId,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return StepModel.fromJson(responseData);
    } else {
      throw ServerFailure(message: 'Error al crear el paso de la receta.');
    }
  }

  @override
  Future<StepModel> updateStep(int stepId, StepModel step) async {
    final url = Uri.parse(
        '$baseUrl/steps/$stepId'); // Solo usamos el `stepId` en la URL
    final response = await client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'description': step.description,
        'order': step.order,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return StepModel.fromJson(responseData);
    } else {
      throw ServerFailure(message: 'Error al actualizar el paso de la receta.');
    }
  }

  @override
  Future<void> deleteStep(int recipeId, int stepId) async {
    final url = Uri.parse('$baseUrl/steps/$recipeId/$stepId');
    final response = await client.delete(url);

    if (response.statusCode != 200) {
      throw ServerFailure(message: 'Error al eliminar el paso de la receta.');
    }
  }

  @override
  Future<void> deleteStepById(int stepId) async {
    final url = Uri.parse('$baseUrl/steps/$stepId');
    final response = await client.delete(url);

    if (response.statusCode != 200) {
      throw ServerFailure(message: 'Error al eliminar el paso.');
    }
  }
}
