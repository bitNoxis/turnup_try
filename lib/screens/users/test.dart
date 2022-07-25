import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turnup_try/utils/firebase.dart';
import '../../models/user.dart';

class OurUsers extends StatefulWidget {
  const OurUsers({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OurUsers();
}

class _OurUsers extends State<OurUsers> {
  final controller = TextEditingController();
  final numberController = TextEditingController();
  static String currentlySelected = '';
  Stream<List<User>> users = readUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Users"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          const BorderSide(color: Colors.lightBlueAccent))),
              onChanged: (text) {
                setState(() {
                  users = readUsersList((user) =>
                      user.name.toLowerCase().contains(text.toLowerCase()));
                });
                // users = readUsersList((user) => user.name.toLowerCase().contains(text.toLowerCase()));
                // readUsersList((user) => user.name.toLowerCase().contains(text.toLowerCase()));
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<User>>(
                stream: users,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    final users = snapshot.data;
                    return ListView(
                      children: users!.map(buildUser).toList(),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            var docUser = FirebaseFirestore.instance
                .collection('Users')
                .doc(currentlySelected);
            var snapshot = await docUser.get();
            User test;
            if (snapshot.exists) {
              test = User.fromJson(snapshot.data()!);
              docUser.update({'points': test.points + 1});
            } else {
              var widget = CupertinoAlertDialog(
                title: const Text('Nothing was found'),
                content: const Text(
                    'Nothing was found in the Database check if you searched correctly.'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('Understood'),
                    onPressed: () {
                      Navigator.pop(context);
                      return;
                    },
                  )
                ],
              );
              showCupertinoDialog(
                  context: context,
                  builder: (_) => widget,
                  barrierDismissible: true);
            }
          }),
    );
  }

  Widget buildUser(User user) => ListTile(
        leading: CircleAvatar(child: Text('${user.points}')),
        title: Text(user.name),
        subtitle: Text(user.id),
        onTap: () {
          numberController.clear();
          updateSelected(user.id);
          currentlySelected = user.id;
        },
      );

  void updateSelected(String id) async {
    var docUser = FirebaseFirestore.instance.collection('Users').doc(id);
    var snapshot = await docUser.get();
    if (snapshot.exists) {
      User userToChange = User.fromJson(snapshot.data()!);
      var widget = CupertinoAlertDialog(
        title: Text(id),
        content: Material(
          type: MaterialType.canvas,
          child: TextField(
            controller: numberController,

            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Never mind'),
            onPressed: () {
              Navigator.pop(context);
              return;
            },
          ),
          CupertinoDialogAction(
            child: const Text('Change'),
            onPressed: () {
              docUser.update({
                'points': userToChange.points +
                    double.parse(numberController.text)
              });
              Navigator.pop(context);
              return;
            },
          )
        ],
      );
      showCupertinoDialog(
          context: context,
          builder: (_) {
            return widget;
          },
          barrierDismissible: true);
    }
  }
}
