import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:turnup_try/models/User.dart';

Future<void> userSetup(String displayName) async {
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  FirebaseAuth auth = FirebaseAuth.instance;

  User user =
      User(id: auth.currentUser!.uid.toString(), name: displayName, points: 0);
  users.add(user.toJson());
  return;
}

Stream<List<User>> readUsers() =>
    FirebaseFirestore.instance.collection('Users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
