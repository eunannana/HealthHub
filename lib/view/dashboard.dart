import 'package:flutter/material.dart';
import 'package:healthhub/controller/auth_controller.dart';
import 'package:healthhub/controller/userdata_controller.dart';
import 'package:healthhub/view/calories.dart';
import 'package:healthhub/view/exercise.dart';
import 'package:healthhub/view/hydration.dart';
import 'package:healthhub/view/login.dart';
import 'package:healthhub/view/rank.dart';
import 'package:healthhub/view/sleep.dart';
import 'package:healthhub/view/target.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatefulWidget {
  final String userId;
  final String bmiResult;
  final String bmiCategory;

  const DashboardView({
    Key? key,
    required this.userId,
    required this.bmiResult,
    required this.bmiCategory,
  }) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  String? username;
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
  Map<String, dynamic> dailySuccessPoint = {};
  Map<String, dynamic> userDataBMI = {};
  int? globalRank;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HealthHub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $username!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            buildBMIResultCard(),
            buildWaterIntakeCard(),
            buildExerciseCard(),
            buildCalorieCountCard(),
            buildSleepTrackingCard(),
            buildGlobalRankCard(),
          ],
        ),
      ),
    );
  }

  Widget buildBMIResultCard() {
    double? bmi = userDataBMI['uBMIResult'];
    String? bmiCategory = userDataBMI['uBMICategory'];
    return Card(
      child: InkWell(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TargetPage(userId: widget.userId, refreshData: refreshData),
            ),
          );
          await fetchData();
        },
        child: ListTile(
          title: const Text('BMI Result'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Result: ${bmi ?? 'no bmi data'}'),
              Text('Category: ${bmiCategory ?? 'no bmi data'}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCalorieCountCard() {
    int calorieCountGoal = userDataBMI['uCalorieRecomendation'] ?? 2000;
    int? calorieCount = dailySuccessPoint['uCalorieCount'];
    bool isCalorieCountMet =
        calorieCount != null && calorieCount <= calorieCountGoal;
    bool isCalorieCountGoalMet = isCalorieCountMet;

    return Card(
        child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Calories(
                userId: widget.userId,
                date: currentDate,
                refreshData: refreshData),
          ),
        );
      },
      child: ListTile(
        title: const Text('Calories'),
        subtitle: Text('${calorieCount ?? 0} cal / $calorieCountGoal cal'),
        trailing: Icon(
          isCalorieCountMet ? Icons.check_circle : Icons.cancel,
          color: isCalorieCountMet ? Colors.green : Colors.red,
        ),
        leading: isCalorieCountGoalMet
            ? const Icon(Icons.star, color: Colors.yellow)
            : null,
      ),
    ));
  }

  Widget buildExerciseCard() {
    int uExerciseRecomendation = userDataBMI['uExerciseRecomendation'] ?? 1800;
    int exerciseDurationGoal = uExerciseRecomendation;
    int? exerciseDuration = dailySuccessPoint['uExerciseDuration'];
    bool isExerciseGoalMet =
        exerciseDuration != null && exerciseDuration >= exerciseDurationGoal;

    return Card(
        child: InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Exercise(
              userId: widget.userId,
              date: currentDate,
              refreshData: refreshData,
            ),
          ),
        );
        await fetchData();
      },
      child: ListTile(
        title: const Text('Exercise'),
        subtitle: Text(
            '${exerciseDuration ?? 0} seconds / $exerciseDurationGoal seconds'),
        trailing: Icon(
          isExerciseGoalMet ? Icons.check_circle : Icons.cancel,
          color: isExerciseGoalMet ? Colors.green : Colors.red,
        ),
        leading: isExerciseGoalMet
            ? const Icon(Icons.star, color: Colors.yellow)
            : null,
      ),
    ));
  }

  Widget buildGlobalRankCard() {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RankPage(userId: widget.userId)),
          );
        },
        child: const ListTile(
          title: Text('Global Rank'),
          subtitle: Text('Click to see your rank'),
          trailing: Icon(Icons.assessment),
        ),
      ),
    );
  }

  Widget buildSleepTrackingCard() {
    int sleepDurationGoal = 360;
    int? sleepDuration = dailySuccessPoint['uSleepDuration'];
    bool isSleepDurationMet =
        sleepDuration != null && sleepDuration >= sleepDurationGoal;
    bool isSleepDurationGoalMet = isSleepDurationMet;

    return Card(
        child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Sleep(
                userId: widget.userId,
                date: currentDate,
                refreshData: refreshData),
          ),
        );
      },
      child: ListTile(
        title: const Text('Sleep Tracking'),
        subtitle:
            Text('${sleepDuration ?? 0} minutes / $sleepDurationGoal minutes'),
        trailing: Icon(
          isSleepDurationGoalMet ? Icons.check_circle : Icons.cancel,
          color: isSleepDurationGoalMet ? Colors.green : Colors.red,
        ),
      ),
    ));
  }

  Widget buildWaterIntakeCard() {
    int uWaterRecomendation = userDataBMI['uWaterRecomendation'] ?? 2000;
    int waterIntakeGoal = uWaterRecomendation;
    int? hydrationLevel = dailySuccessPoint['uHydrationLevel'];
    bool isWaterIntakeMet =
        hydrationLevel != null && hydrationLevel >= waterIntakeGoal;
    bool isWaterIntakeGoalMet = isWaterIntakeMet;

    return Card(
      child: InkWell(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Hydration(
                userId: widget.userId,
                date: currentDate,
                refreshData: refreshData,
              ),
            ),
          );
          await fetchData();
        },
        child: ListTile(
          title: const Text('Hydration'),
          subtitle: Text('$hydrationLevel ml / $waterIntakeGoal ml'),
          trailing: Icon(
            isWaterIntakeMet ? Icons.check_circle : Icons.cancel,
            color: isWaterIntakeMet ? Colors.green : Colors.red,
          ),
          leading: isWaterIntakeGoalMet
              ? const Icon(Icons.star, color: Colors.yellow)
              : null,
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    username = await AuthController().getUserName(widget.userId);

    dailySuccessPoint = await UserDataController()
        .getDailySuccessPoint(widget.userId, currentDate);

    userDataBMI = await UserDataController().getDataBMI(widget.userId);

    globalRank = await UserDataController().getGlobalRank(widget.userId);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> refreshData() async {
    await fetchData();
  }
}
