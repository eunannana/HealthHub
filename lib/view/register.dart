import 'package:flutter/material.dart';
import 'package:healthhub/controller/auth_controller.dart';
import 'package:healthhub/model/user_model.dart';
import 'package:intl/intl.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final formkey = GlobalKey<FormState>();
  final userCr = AuthController();
  final List<String> genderOptions = ['Male', 'Female'];
  String? name;
  String? email;
  String? password;
  String? rePassword;
  String? gender;
  String? dob;
  bool hidePassword = true;
  bool hideRePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  const Text(
                    'Welcome to HealthHub!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Fill your data first!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    onChanged: (value) {
                      name = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email.';
                      }
                      if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      hintText: 'Select your gender',
                      border: OutlineInputBorder(),
                    ),
                    value: gender,
                    onChanged: (value) {
                      gender = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your gender.';
                      }
                      return null;
                    },
                    items: genderOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Text(
                        'Date of Birth',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          selectDate(context);
                        },
                        icon: Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          selectDate(context);
                        },
                        child: Text(
                          dob != null
                              ? DateFormat('dd MMMM yyyy')
                                  .format(DateTime.parse(dob!))
                              : 'Select Date of Birth',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: hidePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password.';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Re-Password',
                      hintText: 'Re-enter your password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hideRePassword = !hideRePassword;
                          });
                        },
                        icon: Icon(
                          hideRePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      rePassword = value;
                    },
                    obscureText: hideRePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please re-enter your password.';
                      }
                      if (value != password) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        try {
                          UserModel? registeredUser =
                              await userCr.createUserWithEmailAndPassword(
                            email!,
                            password!,
                            name!,
                            dob!,
                            gender!,
                          );
                          if (registeredUser != null) {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Registration Successful'),
                                  content: const Text(
                                    'You have been successfully registered.',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } catch (e) {
                          if (e
                              .toString()
                              .contains('Email is already registered')) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Registration Failed'),
                                  content: const Text(
                                      'Email is already registered.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Registration Failed'),
                                  content: const Text(
                                      'An error occurred during registration.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      }
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dob = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
