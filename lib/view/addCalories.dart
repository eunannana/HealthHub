// ignore_for_file: file_names

import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:healthhub/model/food_model.dart';

class AddCalories extends StatefulWidget {
  const AddCalories({Key? key}) : super(key: key);

  @override
  State<AddCalories> createState() => _AddCaloriesState();
}

class _AddCaloriesState extends State<AddCalories> {
  final TextEditingController _caloriesController = TextEditingController();
  String? _selectedFood;
  double _calories = 0.0;
  List<Food> _foods = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Calories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownSearch<String>(
              mode: Mode.MENU, showClearButton: true,
              clearButton: const Icon(Icons.clear, size: Checkbox.width),
              showSelectedItems: true,

              items: _foods.map((food) => food.food).toList(),
              onChanged: _calculateCalories,
              selectedItem: _selectedFood,
              compareFn: (item, selectedItem) => item == selectedItem,
              showSearchBox: true, // Show the search bar
              dropdownSearchDecoration: const InputDecoration(
                labelText: "Food/Beverage",
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _caloriesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Calories',
                    ),
                    enabled: _selectedFood == 'Others',
                  ),
                ),
                const SizedBox(width: 8.0),
                const Text(
                  'cal',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String? food = _selectedFood;
                String calories = _caloriesController.text;

                // Validation
                if (food != null && food.isNotEmpty && calories.isNotEmpty) {
                  // Send the new data back to the previous page
                  Navigator.pop(context, '$food - $calories');
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _foods.clear();
    super.dispose();
  }

  Future<void> fetchData() async {
    // Load the JSON data from the assets
    String jsonData = await DefaultAssetBundle.of(context)
        .loadString('assets/foods_n_calories.json');
    List<dynamic> data = jsonDecode(jsonData);

    // Parse the JSON data into FoodItem objects
    List<Food> foods = data.map((item) => Food.fromJson(item)).toList();

    setState(() {
      _foods = foods;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _calculateCalories(String? food) {
    setState(() {
      _selectedFood = food;

      if (_selectedFood != null) {
        // Find the selected food in the list and get its calories
        Food selectedFoodItem =
            _foods.firstWhere((item) => item.food == _selectedFood);
        _calories = selectedFoodItem.calories;
      } else {
        _calories = 0.0;
      }

      _caloriesController.text = _calories.toString();
    });
  }
}
