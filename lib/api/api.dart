import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/chatroommodel.dart';

class API {
  static User get user => auth.currentUser!;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage=FirebaseStorage.instance;
  static late ChatUser me;
  static Future<bool> userExists() async {
    return (await firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<void> CreateUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatuser = ChatUser(
        image: user.photoURL.toString(),
        about: "Hey, I'm using Let's Chat",
        name: user.displayName.toString(),
        createdAt: time,
        isOnline: "",
        id: user.uid,
        lastActive: time,
        email: user.email.toString(),
        pushToken: '');
    return await firestore.collection("users").doc(user.uid).set(chatuser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>  getAllUsers(){
    return firestore.collection("users").where('id',isNotEqualTo: user.uid).snapshots();
  }

  static Future<void>getSelfInfo()async{
    await firestore.collection("users").doc(user.uid).get().then((user)async{
      if(user.exists){
        me=ChatUser.fromJson(user.data()!);
      }
      else{
        await CreateUser().then((value) => getSelfInfo());
      }
    });
  }
  static Future<void>updateUserInfo()async{
    await firestore.collection("users").doc(user.uid).update({'name':me.name,'about':me.about});
  }
  static Future<void>updateProfilePictures(File file)async{
    final ext=file.path.split('.').last;
    log("Extension: ${ext}");
    final ref=storage.ref().child("profile_pictures/${user.uid}$ext");
    await ref.putFile(file,SettableMetadata(contentType: 'image/$ext')).then((p0){
      log("Data Transferred: ${p0.bytesTransferred/1000} Kb");
    });
    me.image=await ref.getDownloadURL();
    await firestore.collection("profilepictures").doc(user.uid).update({'image':me.image});

  }
}
