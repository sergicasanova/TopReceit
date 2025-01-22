import 'package:flutter_top_receit/data/models/step_model.dart';

class StepEntity {
  final int idStep;
  final String description;
  final int order;

  StepEntity({
    required this.idStep,
    required this.description,
    required this.order,
  });

  factory StepEntity.fromModel(StepModel model) {
    return StepEntity(
      idStep: model.idStep!,
      description: model.description,
      order: model.order,
    );
  }
}
