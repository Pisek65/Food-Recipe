import 'package:flutter/material.dart';
import '/model/RecipeItem.dart';

class RecipeProvider with ChangeNotifier {
  final List<RecipeItem> _recipes = [];

  List<RecipeItem> get recipes => _recipes;

  void addRecipe(RecipeItem recipe) {
    _recipes.add(recipe);
    notifyListeners();
  }

  void updateRecipe(String keyID, String title, String description, String ingredients, String steps) {
    int index = _recipes.indexWhere((recipe) => recipe.keyID == keyID);
    if (index != -1) {
      _recipes[index] = RecipeItem(
        keyID: keyID,
        title: title,
        description: description,
        ingredients: ingredients,
        steps: steps,
        date: _recipes[index].date, // ใช้วันที่เดิม
      );
      notifyListeners();
    }
  }

  void deleteRecipe(String keyID) {
    _recipes.removeWhere((recipe) => recipe.keyID == keyID);
    notifyListeners();
  }
}
