// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:healthhub/controller/auth_controller.dart';
import 'package:healthhub/controller/userdata_controller.dart';

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
        title: const Text('HealthHub Rank'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
              'Name: $username',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: userNamesWithPoints.length,
              itemBuilder: (context, index) {
                final userName = userNamesWithPoints[index]['userName'];
                final successPoint = userNamesWithPoints[index]['successPoint'];
                final order = index + 1;
                IconData? badgeIcon;
                Color? badgeColor;

                if (order == 1) {
                  badgeIcon = Icons.emoji_events;
                  badgeColor = Colors.amber;
                } else if (order == 2) {
                  badgeIcon = Icons.emoji_events;
                  badgeColor = Colors.grey;
                } else if (order == 3) {
                  badgeIcon = Icons.emoji_events;
                  badgeColor = Colors.brown;
                }
                 final isSameUser = userName == username;

                return Card(
                  shape: isSameUser
                      ? RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Color.fromARGB(255, 234, 141, 54),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        )
                      : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: badgeIcon != null
                          ? Icon(
                              badgeIcon,
                              color: badgeColor,
                            )
                          : Text(order.toString()),
                    ),
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
    userNamesWithPoints = await UserDataController().getAllUserNamesWithPoints();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchRanks();
  }
}