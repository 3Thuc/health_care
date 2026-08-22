
class Food {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String? imageUrl;
  final DateTime createdAt;

  Food({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.imageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Food copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    String? imageUrl,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt,
    );
  }
}
