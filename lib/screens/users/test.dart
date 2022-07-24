import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turnup_try/utils/firebase.dart';

import '../../models/User.dart';

class OurUsers extends StatelessWidget {
  const OurUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Users"),
      ),
      body: StreamBuilder<List<User>>(
          stream: readUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong ${snapshot.error}");
            } else if (snapshot.hasData) {
              final users = snapshot.data;

              return ListView(children: users!.map(buildUser).toList());
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget buildUser(User user) => ListTile(
      leading: CircleAvatar(child: Text('${user.points}')),
      title: Text(user.name),
      subtitle: Text(user.id));
}
