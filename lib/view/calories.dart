import 'package:flutter/material.dart';
import 'package:healthhub/view/addCalories.dart';

class Calories extends StatefulWidget {
  final List<String> data;

  const Calories({Key? key, required this.data}) : super(key: key);

  @override
  _CaloriesState createState() => _CaloriesState();
}

class _CaloriesState extends State<Calories> {
  List<String> _caloriesData = [];

  @override
  void initState() {
    super.initState();
    _caloriesData = List.from(widget.data);
  }

  void _deleteData(int index) {
    setState(() {
      _caloriesData.removeAt(index);
    });
  }

  void _navigateToAddCalories(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCalories()),
    );

    if (result != null) {
      setState(() {
        _caloriesData.add(result);
      });
    }
  }

  double calculateTotalCalories() {
    double totalCalories = 0;
    for (String data in _caloriesData) {
      List<String> splittedData = data.split(' - ');
      String calories = splittedData[1].replaceAll(' cal', '');
      totalCalories += double.parse(calories);
    }
    return totalCalories;
  }

  void _saveTotalCalories(BuildContext context) {
    
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calories View'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Calories: ${calculateTotalCalories().toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () => _saveTotalCalories(context),
                  child: Text('Save'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _caloriesData.length,
              itemBuilder: (BuildContext context, int index) {
                String data = _caloriesData[index];
                List<String> splittedData = data.split(' - ');
                String food = splittedData[0];
                String calories = splittedData[1];

                return Dismissible(
                  key: Key(data),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _deleteData(index);
                    });
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(food),
                      subtitle: Text('$calories cal'),
                      trailing: Icon(
                        Icons.swipe_left_alt,
                        color: Color.fromARGB(70, 211, 67, 57),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddCalories(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
