// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthhub/controller/userdata_controller.dart';
import 'package:healthhub/view/addCalories.dart';

class Calories extends StatefulWidget {
  final String userId;
  final String date;
  final Function refreshData;

  const Calories(
      {Key? key,
      required this.userId,
      required this.refreshData,
      required this.date})
      : super(key: key);
  @override
  _CaloriesState createState() => _CaloriesState();
}

class _CaloriesState extends State<Calories> {
  late String date;
  Map<String, dynamic> userData = {};
  late int hydrationLevel;
  late int exerciseDuration;
  late int calorieCount;
  late int sleepDuration;
  List<String> caloriesData = [];
  Map<String, dynamic> caloriesDataMap = {};

  double totalCalories = 0;
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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () => _saveTotalCalories(context),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: caloriesData.length,
              itemBuilder: (BuildContext context, int index) {
                String data = caloriesData[index];
                List<String> splittedData = data.split(' - ');
                String food = splittedData[0];
                String calories = splittedData[1];

                return Dismissible(
                  key: Key(data),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.0),
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
                      trailing: const Icon(
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

  double calculateTotalCalories() {
    double total = 0;
    for (String data in caloriesData) {
      List<String> splittedData = data.split(' - ');
      String calories = splittedData[1].replaceAll(' cal', '');
      total += double.parse(calories);
    }
    return total;
  }

  Future<void> fetchData() async {
    caloriesDataMap =
        await UserDataController().getDailyCaloriesData(widget.userId, date);

    userData =
        await UserDataController().getDailySuccessPoint(widget.userId, date);

    hydrationLevel = userData['uHydrationLevel'] ?? 0;
    exerciseDuration = userData['uExerciseDuration'] ?? 0;
    calorieCount = userData['uCalorieCount'] ?? 0;
    sleepDuration = userData['uSleepDuration'] ?? 0;

    setState(() {
      totalCalories = calorieCount.toDouble();
      caloriesData = caloriesDataMap['caloriesData'] != null
          ? List<String>.from(caloriesDataMap['caloriesData'])
          : [];
    });
  }

  @override
  void initState() {
    super.initState();
    date = widget.date;
    fetchData();
  }

  void _deleteData(int index) {
    setState(() {
      caloriesData.removeAt(index);
    });
  }

  void _navigateToAddCalories(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCalories()),
    );

    if (result != null) {
      setState(() {
        caloriesData.add(result);
      });
    }
  }

  void _saveTotalCalories(BuildContext context) async {
    await UserDataController().updateDailySuccessPoint(
      widget.userId,
      date,
      hydrationLevel,
      exerciseDuration,
      calculateTotalCalories().toInt(),
      sleepDuration,
    );
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference userRef =
        firestore.collection('users').doc(widget.userId);
    final DocumentReference caloriesRef = userRef
        .collection('uDailysuccesspoint')
        .doc(date)
        .collection('uCalories')
        .doc('data');

    await caloriesRef.set({
      'caloriesData': caloriesData,
    });
    widget.refreshData();

    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Total calories saved')),
    );
  }
}
