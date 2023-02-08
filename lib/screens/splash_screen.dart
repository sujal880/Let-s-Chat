import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letschat/api/api.dart';
import 'package:letschat/screens/homescreen.dart';
import 'package:lottie/lottie.dart';
import '../main.dart';
import 'auth/login_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 4000),(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white,systemNavigationBarColor: Colors.white));
      if(API.auth.currentUser!=null){
        log("${API.auth.currentUser!.uid}");
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomeScreen()));
      }else{
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: mq.height*.30,
              width: mq.width*.5,
              right: mq.width*.25,
              child: Image.asset("images/conversation.png")
          ),
          Positioned(
              bottom: mq.height*.15,
              width: mq.width,
              child: Text("Welcome To Let's Chat",style: TextStyle(fontSize: 26,color: Colors.black,letterSpacing: .5,fontWeight: FontWeight.w500),textAlign: TextAlign.center))
        ],
      ),
    );
  }
}
