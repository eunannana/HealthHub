// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:healthhub/controller/userdata_controller.dart';

class Exercise extends StatefulWidget {
  final String userId;
  final String date;
  final Function refreshData;
  const Exercise({
    Key? key,
    required this.userId,
    required this.date,
    required this.refreshData,
  }) : super(key: key);

  @override
  State<Exercise> createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  late String date = widget.date;
  Map<String, dynamic> userData = {};
  late int hydrationLevel;
  late int exerciseDuration;
  late int calorieCount;
  late int sleepDuration;

  bool _isRunning = false;
  int _totalSeconds = 0;
  Timer _timer = Timer.periodic(const Duration(seconds: 0), (timer) {});

  @override
  Widget build(BuildContext context) {
    String timerText = _formatTime(_totalSeconds);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Have I exercised today?',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              timerText,
              style: const TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: !_isRunning ? _startTimer : null,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _isRunning ? _stopTimer : null,
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: !_isRunning ? _resetTimer : null,
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: !_isRunning ? _saveData : null,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    // date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    userData =
        await UserDataController().getDailySuccessPoint(widget.userId, date);

    hydrationLevel = userData['uHydrationLevel'] ?? 0;
    exerciseDuration = userData['uExerciseDuration'] ?? 0;
    calorieCount = userData['uCalorieCount'] ?? 0;
    sleepDuration = userData['uSleepDuration'] ?? 0;

    setState(() {
      _totalSeconds = exerciseDuration;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  String _formatTime(int time) {
    int hours = (time ~/ 3600) % 60;
    int minutes = (time ~/ 60) % 60;
    int seconds = time % 60;
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$hoursStr:$minutesStr:$secondsStr';
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _totalSeconds = 0;
    });
  }

  void _saveData() async {
    // String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await UserDataController().updateDailySuccessPoint(
      widget.userId,
      date,
      hydrationLevel,
      _totalSeconds,
      calorieCount,
      sleepDuration,
    );

    widget.refreshData();
    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exercise duration saved')),
    );
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _totalSeconds++;
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
    });

    _timer.cancel();
  }
}
