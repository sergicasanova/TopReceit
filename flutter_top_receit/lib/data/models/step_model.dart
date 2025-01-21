class StepModel {
  final int idStep;
  int? idRecipe;
  final String description;
  final int order;

  StepModel({
    required this.idStep,
    this.idRecipe,
    required this.description,
    required this.order,
  });

  factory StepModel.fromJson(Map<String, dynamic> json) {
    return StepModel(
      idStep: json['id_steps'],
      description: json['description'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_steps': idStep,
      'recipe_id': idRecipe,
      'description': description,
      'order': order,
    };
  }

  StepModel copyWith({
    int? idStep,
    int? idRecipe,
    String? description,
    int? order,
  }) {
    return StepModel(
      idStep: idStep ?? this.idStep,
      idRecipe: idRecipe ?? this.idRecipe,
      description: description ?? this.description,
      order: order ?? this.order,
    );
  }
}
