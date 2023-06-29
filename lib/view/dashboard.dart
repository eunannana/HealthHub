import 'package:healthhub/view/login.dart';
import 'package:healthhub/view/register.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatelessWidget {
  final String username;
  final int waterIntake;
  final bool isExerciseDone;
  final int calorieCount;
  final bool isSleepTracked;
  final bool isSick;
  final int globalRank;

  const DashboardView({
    Key? key,
    required this.username,
    required this.waterIntake,
    required this.isExerciseDone,
    required this.calorieCount,
    required this.isSleepTracked,
    required this.isSick,
    required this.globalRank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('HealthHub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $username!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            buildWaterIntakeCard(),
            buildExerciseCard(),
            buildCalorieCountCard(),
            buildSleepTrackingCard(),
            // buildSickOptionsCard(),
            buildGlobalRankCard(),
          ],
        ),
      ),
    );
  }

  Widget buildWaterIntakeCard() {
    bool isWaterIntakeMet = waterIntake >= 2000;
    bool isWaterIntakeGoalMet = isWaterIntakeMet;
    int waterIntakeGoal = 2000;

    return Card(
      child: ListTile(
        title: const Text('Kadar Hidrasi'),
        subtitle: Text('$waterIntake ml / $waterIntakeGoal ml'),
        trailing: Icon(
          isWaterIntakeMet ? Icons.check_circle : Icons.cancel,
          color: isWaterIntakeMet ? Colors.green : Colors.red,
        ),
        leading: isWaterIntakeGoalMet
            ? const Icon(Icons.star, color: Colors.yellow)
            : null,
      ),
    );
  }

  Widget buildExerciseCard() {
    bool isExerciseGoalMet = isExerciseDone;
    // bool isExerciseGoal = true;

    return Card(
      child: ListTile(
        title: const Text('Exercise'),
        // subtitle: Text(isExerciseGoal ? 'Selesai' : 'Belum selesai'),
        trailing: Icon(
          isExerciseGoalMet ? Icons.check_circle : Icons.cancel,
          color: isExerciseGoalMet ? Colors.green : Colors.red,
        ),
        leading: isExerciseGoalMet
            ? const Icon(Icons.star, color: Colors.yellow)
            : null,
      ),
    );
  }

  Widget buildCalorieCountCard() {
    bool isCalorieCountMet = calorieCount <= 2000;
    bool isCalorieCountGoalMet = isCalorieCountMet;
    int calorieCountGoal = 2000;

    return Card(
      child: ListTile(
        title: const Text('Menghitung Kalori Makanan'),
        subtitle: Text('$calorieCount kcal / $calorieCountGoal kcal'),
        trailing: Icon(
          isCalorieCountMet ? Icons.check_circle : Icons.cancel,
          color: isCalorieCountMet ? Colors.green : Colors.red,
        ),
        leading: isCalorieCountGoalMet
            ? const Icon(Icons.star, color: Colors.yellow)
            : null,
      ),
    );
  }

  Widget buildSleepTrackingCard() {
    bool isSleepTrackingMet = isSleepTracked;
    bool isSleepTrackingGoalMet = isSleepTrackingMet;
    // bool isSleepTrackingGoal = true;

    return Card(
      child: ListTile(
        title: const Text('Tracking Pola Tidur'),
        // subtitle: Text(isSleepTrackingGoal ? 'Terkonfirmasi' : 'Belum terkonfirmasi'),
        trailing: Icon(
          isSleepTrackingMet ? Icons.check_circle : Icons.cancel,
          color: isSleepTrackingMet ? Colors.green : Colors.red,
        ),
        leading: isSleepTrackingGoalMet
            ? const Icon(Icons.star, color: Colors.yellow)
            : null,
      ),
    );
  }

  // Widget buildSickOptionsCard() {
  //   bool isSickOptionsMet = isSick;
  //   bool isSickOptionsGoalMet = isSickOptionsMet;
  //   // bool isSickOptionsGoal = true;

  //   return Card(
  //     child: ListTile(
  //       title: const Text('Opsi Tambahan saat Sakit'),
  //       // subtitle: Text(isSickOptionsGoal ? 'Tersedia' : 'Tidak tersedia'),
  //       trailing: Icon(
  //         isSickOptionsMet ? Icons.check_circle : Icons.cancel,
  //         color: isSickOptionsMet ? Colors.green : Colors.red,
  //       ),
  //       leading: isSickOptionsGoalMet
  //           ? const Icon(Icons.star, color: Colors.yellow)
  //           : null,
  //     ),
  //   );
  // }

  Widget buildGlobalRankCard() {
    bool isGlobalRankMet = globalRank <= 5;
    bool isGlobalRankGoalMet = isGlobalRankMet;
    // int globalRankGoal = 5;

    return Card(
      child: ListTile(
        title: const Text('Global Rank'),
        subtitle: isGlobalRankMet
            ? const Text('Anda masuk ke dalam 5 orang sehat dari user lainnya')
            : const Text(
                'Anda belum masuk ke dalam 5 orang sehat dari user lainnya'),
        trailing: Icon(
          isGlobalRankMet ? Icons.check_circle : Icons.cancel,
          color: isGlobalRankMet ? Colors.green : Colors.red,
        ),
        leading: isGlobalRankGoalMet
            ? const Icon(Icons.star, color: Colors.yellow)
            : null,
      ),
    );
  }

  void logout(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}
