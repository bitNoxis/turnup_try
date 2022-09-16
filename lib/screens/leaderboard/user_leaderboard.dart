import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turnup_try/currently_logged_in.dart';
import 'package:turnup_try/utils/firebase.dart';
import '../../models/user.dart';

enum UserOrderBy { points, name }

enum SortOptions {
  most('Meisten Punkte', UserOrderBy.points, true),
  least('Wenigsten Punkte', UserOrderBy.points, false),
  namedown('Name Absteigend', UserOrderBy.name, false),
  nameup('Name Aufsteigend', UserOrderBy.name, true);

  const SortOptions(this.description, this.userOrderBy, this.descending);

  final String description;
  final UserOrderBy userOrderBy;
  final bool descending;
}

class OurUsers extends StatefulWidget {
  const OurUsers({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OurUsers();
}

class _OurUsers extends State<OurUsers> {
  final controller = TextEditingController();
  final numberController = TextEditingController();
  SortOptions currentSelectedOption = SortOptions.values[0];
  Stream<List<User>> users = readUsers((user) => true,
      SortOptions.most.userOrderBy.name, SortOptions.most.descending);

  @override
  Widget build(BuildContext context) {
    final items = SortOptions.values
        .map((sortOption) => PopupMenuItem(
              value: sortOption.name,
              child: Text(sortOption.description),
              onTap: () {
                setState(() {
                  currentSelectedOption = sortOption;
                  users = readUsers(
                      (user) => true,
                      currentSelectedOption.userOrderBy.name,
                      currentSelectedOption.descending);
                });
              },
            ))
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Leaderboard"),
          centerTitle: true,
          actions: [
            PopupMenuButton<String>(
                onSelected: (value) => setState(() {
                      currentSelectedOption = SortOptions.values.firstWhere(
                          (element) => element.name == value,
                          orElse: () => SortOptions.most);
                    }),
                initialValue: currentSelectedOption.name,
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
                                    (user) => true,
                                    currentSelectedOption.userOrderBy.name,
                                    currentSelectedOption.descending);
                                controller.clear();
                              });
                            },
                            icon: const Icon(Icons.clear)),
                        hintText: 'Search',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Colors.lightBlueAccent))),
                    onChanged: (text) {
                      setState(() {
                        users = readUsers(
                            (user) => user.name
                                .toLowerCase()
                                .contains(text.toLowerCase()),
                            currentSelectedOption.userOrderBy.name,
                            currentSelectedOption.descending);
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
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ),
              ],
            )));
  }

  Widget buildUser(User user) => ListTile(
        tileColor: user.id == loggedInUser!.id ? Colors.green : null,
        leading: CircleAvatar(
          radius: 40,
          child: Text(user.points.toStringAsFixed(1)),
        ),
        title: Text(user.id == loggedInUser!.id ? 'You' : user.name),
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
              double pointsToAdd =
                  double.parse(numberController.text.replaceAll(',', '.'));
              loggedInUser!.points += pointsToAdd;
              docUser.update({'points': userToChange.points + pointsToAdd});
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
