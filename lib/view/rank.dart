import 'package:flutter/material.dart';

class UserRank {
  final String userId;
  final int rank;

  UserRank(this.userId, this.rank);
}

class RankPage extends StatefulWidget {
  @override
  _RankPageState createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  List<UserRank> ranks = [];

  @override
  void initState() {
    super.initState();
    fetchRanks();
  }

  Future<void> fetchRanks() async {
    // Simulate fetching ranks from database or API
    await Future.delayed(Duration(seconds: 2));

    // Dummy data for demonstration
    List<UserRank> dummyRanks = [
      UserRank('user1', 1),
      UserRank('user2', 2),
      UserRank('user3', 3),
      UserRank('user4', 4),
      UserRank('user5', 5),
    ];

    setState(() {
      ranks = dummyRanks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rank Page'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: ranks.length,
          itemBuilder: (context, index) {
            UserRank userRank = ranks[index];
            return ListTile(
              leading: Text(userRank.rank.toString()),
              title: Text('User ID: ${userRank.userId}'),
            );
          },
        ),
      ),
    );
  }
}
