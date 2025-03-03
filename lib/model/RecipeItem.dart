class RecipeItem {
  final String keyID;
  final String title;
  final String description;
  final String ingredients;
  final String steps;
  final String category;
  final DateTime date;

  RecipeItem({
    required this.keyID,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.category,
    required this.date,
  });
}
