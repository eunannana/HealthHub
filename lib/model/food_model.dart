class Food {
  final String food;
  final double calories;

  Food(this.food, this.calories);

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      json['food'] as String,
      json['calories'] as double,
    );
  }
}
