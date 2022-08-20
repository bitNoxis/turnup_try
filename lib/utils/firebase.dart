import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:turnup_try/models/user.dart';
import 'package:turnup_try/models/markers.dart';

Future<void> userSetup(String displayName) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("Users");

  User user =
      User(id: auth.currentUser!.uid.toString(), name: displayName, points: 0);
  users.doc(auth.currentUser!.uid.toString()).set(user.toJson());
  return;
}

Stream<List<User>> readUsers(bool Function(User) whereName, String orderByString, bool descending) =>
    FirebaseFirestore.instance.collection('Users').orderBy(orderByString, descending: descending)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => User.fromJson(doc.data()))
            .where(whereName)
            .toList());

Stream<List<MapMarker>> readLocations() =>
 FirebaseFirestore.instance.collection('Locations').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => MapMarker.fromJson(doc.data())).toList());

Future<void> setupLocation(MapMarker marker) async {
  CollectionReference locations = FirebaseFirestore.instance.collection('Locations');
  await locations.doc(marker.title).set(marker.toJson());
}

