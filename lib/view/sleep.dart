// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:healthhub/controller/userdata_controller.dart';

class Sleep extends StatefulWidget {
  final String userId;
  final String date;
  final Function refreshData;

  const Sleep(
      {Key? key,
      required this.userId,
      required this.refreshData,
      required this.date})
      : super(key: key);

  @override
  _SleepState createState() => _SleepState();
}

class _SleepState extends State<Sleep> {
  late String date = widget.date;
  Map<String, dynamic> userData = {};
  late int hydrationLevel;
  late int exerciseDuration;
  late int calorieCount;
  late int sleepDuration;

  bool _isSleeping = false;
  DateTime? _sleepStartTime;
  DateTime? _sleepEndTime;
  Duration? _differenceTime;
  Duration? _totalSleepDuration = const Duration(hours: 0, minutes: 0);
  final Duration _totalSleepDurationNull = const Duration(hours: 0, minutes: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Tracking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Now I am:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              _isSleeping ? 'Sleeping' : 'Awake',
              style: const TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isSleeping ? _endSleep : _startSleep,
              child: Text(_isSleeping ? 'Wake up' : 'Sleep'),
            ),
            const SizedBox(height: 32.0),
            if (_totalSleepDuration != _totalSleepDurationNull)
              Text(
                'I have already slept for ${_formatTime(_totalSleepDuration!)}',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              )
            else
              const Text(
                'I havent sleep yet',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: !_isSleeping ? _saveSleepData : null,
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

    Duration intToDuration(int durationInMinutes) {
      int hours = durationInMinutes ~/ 60;
      int minutes = durationInMinutes % 60;
      return Duration(hours: hours, minutes: minutes);
    }

    setState(() {
      _totalSleepDuration = intToDuration(sleepDuration);
      print('_totalSleepDuration = $_totalSleepDuration');
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _endSleep() {
    setState(() {
      _isSleeping = false;
      _sleepEndTime = DateTime.now();
      _differenceTime = _sleepEndTime!.difference(_sleepStartTime!);
      print('_differenceTime = $_differenceTime');
      Duration dur1 = _differenceTime!;
      Duration dur2 = _totalSleepDuration!;
      _totalSleepDuration = dur1 + dur2;
    });
  }

  String _formatTime(Duration duration) {
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    if (minutesStr != '00') {
      if (secondsStr != '00') {
        return '$minutesStr minutes $secondsStr seconds';
      }
      return '$minutesStr minutes';
    } else {
      return '$secondsStr seconds';
    }
  }

  void _saveSleepData() async {
    if (_isSleeping || _totalSleepDuration == null) {
      return;
    }

    int sleepDurationInMinutes = _totalSleepDuration!.inMinutes;

    await UserDataController().updateDailySuccessPoint(
      widget.userId,
      date,
      hydrationLevel,
      exerciseDuration,
      calorieCount,
      sleepDurationInMinutes,
    );

    widget.refreshData();
    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sleep duration saved')),
    );
  }

  void _startSleep() {
    setState(() {
      _isSleeping = true;
      _sleepStartTime = DateTime.now();
    });
  }
}
