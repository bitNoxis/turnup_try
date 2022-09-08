import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:turnup_try/currently_logged_in.dart';

class ProfileView extends StatefulWidget {
  static String route = "profile-view";

  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    loggedInUser!.photoUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      XFile? image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      FirebaseStorage storage = FirebaseStorage.instance;
                      Reference ref = storage
                          .ref('profilepictures')
                          .child('${loggedInUser!.id}ProfilePicture');
                      UploadTask task = ref.putFile(File(image!.path));
                      task.then((snapshot) {
                        snapshot.ref.getDownloadURL().then((value) {
                          setState(() {
                            loggedInUser!.photoUrl = value;
                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(loggedInUser!.id)
                                .update({'photoURL': value});
                          });
                        });
                      });
                    },
                    child: Center(
                      child: loggedInUser!.photoUrl.isEmpty
                          ? const CircleAvatar(
                              radius: 50.0,
                              child: Icon(Icons.photo_camera),
                            )
                          : CircleAvatar(
                              radius: 50.0,
                              backgroundImage:
                                  NetworkImage(loggedInUser!.photoUrl),
                            ),
                    ),
                  ),
                  Text("Hi ${loggedInUser!.name} nice to see you here."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
