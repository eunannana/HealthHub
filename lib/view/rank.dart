// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:healthhub/controller/auth_controller.dart';

class RankPage extends StatefulWidget {
  final String userId;

  const RankPage({
    Key? key,
    required this.userId,
  }) : super(key: key);
  @override
  _RankPageState createState() => _RankPageState();
}

class UserRank {
  final String userId;
  final int rank;

  UserRank(this.userId, this.rank);
}

class _RankPageState extends State<RankPage> {
  String? username;
  List<Map<String, dynamic>> userNamesWithPoints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rank Page'),
      ),
      body: Column(
        children: [
          Text('Name: $username'),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: userNamesWithPoints.length,
              itemBuilder: (context, index) {
                final userName = userNamesWithPoints[index]['userName'];
                final successPoint = userNamesWithPoints[index]['successPoint'];
                final order = index + 1;
                return Card(
                  child: ListTile(
                    leading: Text(order.toString()),
                    title: Text(userName),
                    subtitle: Text('Success Point: $successPoint'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchRanks() async {
    username = await AuthController().getUserName(widget.userId);
    userNamesWithPoints = await AuthController().getAllUserNamesWithPoints();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchRanks();
  }
}
