// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:healthhub/controller/userdata_controller.dart';
import 'package:healthhub/view/dashboard.dart';
import 'package:flutter/material.dart';

class TargetPage extends StatefulWidget {
  final String userId;
  final Function refreshData;
  const TargetPage({Key? key, required this.userId, required this.refreshData})
      : super(key: key);

  @override
  _TargetPageState createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  Map<String, dynamic> userDataBMI = {};
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  double? bmiResult;
  String? bmiCategory;
  int? waterRecommendation;
  int? sleepRecommendation;
  int? exerciseRecommendation;
  int? calorieRecommendation;

  Future<void> fetchData() async {
    userDataBMI = await UserDataController().getDataBMI(widget.userId);

    setState(() {
      String? weight = userDataBMI['uWeight'].toString();
      String? height = userDataBMI['uHeight'].toString();
      _weightController.text = weight;
      _heightController.text = height;
      bmiResult = userDataBMI['uBMIResult'] ?? 0;
      bmiCategory = userDataBMI['uBMICategory'] ?? '';
      waterRecommendation = userDataBMI['uWaterRecomendation'] ?? 0;
      sleepRecommendation = userDataBMI['uSleepRecomendation'] ?? 0;
      exerciseRecommendation = userDataBMI['uExerciseRecomendation'] ?? 0;
      calorieRecommendation = userDataBMI['uCalorieRecomendation'] ?? 0;
    });
    
    
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'BMI Calculator',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              buildWeightTextFieldForm(),
              const SizedBox(height: 8),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: calculateBMI,
                child: const Text('Calculate'),
              ),
              const SizedBox(height: 16),
              buildBMIText(),
              const SizedBox(height: 8),
              buildBMICategory(),
              const SizedBox(height: 16),
              const Text('Target Recommendations:'),
              const SizedBox(height: 8),
              Text('Drink water $waterRecommendation ml in a day'),
              Text('Sleep $sleepRecommendation hours in a day'),
              Text('Exercise $exerciseRecommendation minutes in a day'),
              Text('Eat $calorieRecommendation calories in a day'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: saveData,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text buildBMIText() {
    return Text(
      'BMI Result: $bmiResult',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text buildBMICategory() {
    String bmiCategory = userDataBMI['uBMICategory'] ?? 'no data';
    return Text(
      'BMI Category: $bmiCategory',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextField buildWeightTextFieldForm() {
    return TextField(
      controller: _weightController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Weight (kg)',
      ),
    );
  }

  void calculateBMI() {
    if (_weightController.text.isEmpty || _heightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    double weight, height;
    try {
      weight = double.parse(_weightController.text);
      height = double.parse(_heightController.text);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numeric values')),
      );
      return;
    }

    if (weight <= 0 || height <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter positive values')),
      );
      return;
    }

    double bmi = weight / ((height / 100) * (height / 100));
    int bmiInt = int.tryParse(bmi.toStringAsFixed(0)) ?? 0;

    setState(() {
      bmiResult = bmiInt.toDouble();

      if (bmi < 18.5) {
        bmiCategory = 'Underweight';
        waterRecommendation = 2000;
        sleepRecommendation = 8;
        exerciseRecommendation = 30;
        calorieRecommendation = 2000;
        // waterRecommendation = 'Drink water 2000 ml in a day';
        // sleepRecommendation = 'Sleep 8 hours in a day';
        // exerciseRecommendation = 'Exercise 30 minutes in a day';
        // calorieRecommendation = 'Eat 2000 calories in a day';
      } else if (bmi >= 18.5 && bmi < 25) {
        bmiCategory = 'Normal Weight';
        waterRecommendation = 2000;
        sleepRecommendation = 8;
        exerciseRecommendation = 30;
        calorieRecommendation = 2500;
        // waterRecommendation = 'Drink water 2000 ml in a day';
        // sleepRecommendation = 'Sleep 8 hours in a day';
        // exerciseRecommendation = 'Exercise 30 minutes in a day';
        // calorieRecommendation = 'Eat 2500 calories in a day';
      } else if (bmi >= 25 && bmi < 30) {
        bmiCategory = 'Overweight';
        waterRecommendation = 2000;
        sleepRecommendation = 8;
        exerciseRecommendation = 60;
        calorieRecommendation = 2000;
        // waterRecommendation = 'Drink water 2000 ml in a day';
        // sleepRecommendation = 'Sleep 8 hours in a day';
        // exerciseRecommendation = 'Exercise 60 minutes in a day';
        // calorieRecommendation = 'Eat 2000 calories in a day';
      } else {
        bmiCategory = 'Obese';
        waterRecommendation = 2000;
        sleepRecommendation = 8;
        exerciseRecommendation = 60;
        calorieRecommendation = 1500;
        // waterRecommendation = 'Drink water 2000 ml in a day';
        // sleepRecommendation = 'Sleep 8 hours in a day';
        // exerciseRecommendation = 'Exercise 60 minutes in a day';
        // calorieRecommendation = 'Eat 1500 calories in a day';
      }
    });
  }

  void saveData() async {
    int weightInt = int.parse(_weightController.text);
    int heightInt = int.parse(_heightController.text);
    if (_weightController.text.isEmpty || _heightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
    // Save data BMI to database
    await UserDataController().updateBMI(
      widget.userId,
      weightInt,
      heightInt,
      bmiResult!,
      bmiCategory!,
      waterRecommendation!,
      sleepRecommendation!,
      exerciseRecommendation!,
      calorieRecommendation!,
    );

    widget.refreshData();

    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('BMI Data saved')),
    );
  }
}