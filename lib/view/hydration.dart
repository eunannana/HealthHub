// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:healthhub/controller/userdata_controller.dart';

class Hydration extends StatefulWidget {
  final String userId;
  final String date;
  final Function refreshData;

  const Hydration(
      {Key? key,
      required this.userId,
      required this.refreshData,
      required this.date})
      : super(key: key);

  @override
  State<Hydration> createState() => _HydrationState();
}

class _HydrationState extends State<Hydration> {
  late String date = widget.date;
  Map<String, dynamic> userData = {};
  late int hydrationLevel;
  late int exerciseDuration;
  late int calorieCount;
  late int sleepDuration;

  double waterIntake = 0;
  final int _mlPerGlass = 250;
  final int waterIntakeGoal = 8;
  final int waterIntakeGoalInMl = 2000;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydration View'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'How much water do I drink in a day:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _decrementGlassCount,
                ),
                const SizedBox(width: 8.0),
                Text(
                  waterIntake.toStringAsFixed(0),
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8.0),
                const Text(
                  'glass',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _incrementGlassCount,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              _getProgressText(),
              style: const TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Text(
              '(1 glass = $_mlPerGlass ml)',
              style: const TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveData,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    userData =
        await UserDataController().getDailySuccessPoint(widget.userId, date);

    hydrationLevel = userData['uHydrationLevel'] ?? 0;
    exerciseDuration = userData['uExerciseDuration'] ?? 0;
    calorieCount = userData['uCalorieCount'] ?? 0;
    sleepDuration = userData['uSleepDuration'] ?? 0;

    setState(() {
      waterIntake = hydrationLevel / _mlPerGlass;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  int _calculateMl() {
    return (waterIntake * _mlPerGlass).toInt();
  }

  void _decrementGlassCount() {
    setState(() {
      if (waterIntake > 0) {
        waterIntake--;
      }
    });
  }

  String _getProgressText() {
    int consumedMl = _calculateMl();
    String progressText = '$consumedMl ml';

    if (consumedMl < waterIntakeGoalInMl) {
      int remainingMl = waterIntakeGoalInMl - consumedMl;
      progressText += ' / $remainingMl ml remaining';
    } else {
      progressText += ' / Target achieved!';
    }

    return progressText;
  }

  void _incrementGlassCount() {
    setState(() {
      waterIntake++;
    });
  }

  void _saveData() async {
    // String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await UserDataController().updateDailySuccessPoint(
      widget.userId,
      date,
      _calculateMl(),
      exerciseDuration,
      calorieCount,
      sleepDuration,
    );

    widget.refreshData();

    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hydration level saved')),
    );
  }
}
