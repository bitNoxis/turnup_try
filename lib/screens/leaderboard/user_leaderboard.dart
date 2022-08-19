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
  String popUpValue = 'most';
  String orderBy = 'points';
  bool descending = true;
  Stream<List<User>> users = readUsers((user) => true, 'points', true);

  @override
  Widget build(BuildContext context) {
    final items = [
      PopupMenuItem(
        value: 'most',
        child: const Text('Meisten Punkte'),
        onTap: () {
          setState(() {
            orderBy = 'points';
            descending = true;
            users = readUsers((p0) => true, orderBy, descending);
          });
        },
      ),
      PopupMenuItem(
        value: 'least',
        child: const Text('Wenigsten Punkte'),
        onTap: () {
          setState(() {
            orderBy = 'points';
            descending = false;
            users = readUsers((user) => true, orderBy, descending);
          });
        },
      ),
      PopupMenuItem(
        value: 'nameup',
        child: const Text('Nach Name absteigend'),
        onTap: () => setState(() {
          orderBy = 'name';
          descending = false;
          users = readUsers((user) => true, orderBy, descending);
        }),
      ),
      PopupMenuItem(
        value: 'namedown',
        child: const Text('Nach Name aufsteigend'),
        onTap: () => setState(() {
          orderBy = 'name';
          descending = true;
          users = readUsers((user) => true, orderBy, descending);
        }),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard"),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
              onSelected: (value) => setState(() {
                    popUpValue = value;
                  }),
              initialValue: popUpValue,
              splashRadius: 20,
              icon: const Icon(Icons.sort),
              itemBuilder: (_) => items)
        ],
      ),
      body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              FocusManager.instance.primaryFocus?.unfocus();
                              users = readUsers(
                                  (user) => true, orderBy, descending);
                              controller.clear();
                            });
                          },
                          icon: const Icon(Icons.clear)),
                      hintText: 'Search',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.lightBlueAccent))),
                  onChanged: (text) {
                    setState(() {
                      users = readUsers(
                          (user) => user.name
                              .toLowerCase()
                              .contains(text.toLowerCase()),
                          orderBy,
                          descending);
                    });
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
          )),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), onPressed: () async {}),
    );
  }

  Widget buildUser(User user) => ListTile(
        leading: CircleAvatar(
          radius: 40,
          child: Text(user.points.toStringAsFixed(1)),
        ),
        title: Text(user.name),
        subtitle: Text(user.id),
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          numberController.clear();
          updateSelected(user);
        },
      );

  void updateSelected(User user) async {
    var docUser = FirebaseFirestore.instance.collection('Users').doc(user.id);
    var snapshot = await docUser.get();
    if (snapshot.exists) {
      User userToChange = User.fromJson(snapshot.data()!);
      var widget = CupertinoAlertDialog(
        title: Text(user.name),
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
                    double.parse(numberController.text.replaceAll(',', '.'))
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
