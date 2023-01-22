import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letschat/models/chatroommodel.dart';
import 'package:letschat/screens/auth/login_screen.dart';
import 'package:letschat/screens/profile_screen.dart';
import 'package:letschat/widgets/chat_user_card.dart';

import '../api/api.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  final List<ChatUser> searchList=[];
  bool _isSearching=false;
  @override
  void initState() {
    super.initState();
    API.getSelfInfo();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap:()=>FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: (){
          if(_isSearching){
            setState(() {
              _isSearching=!_isSearching;
            });
            return Future.value(false);
          }
          else{
            return Future.value(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              leading:
                  IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.home)),
              title: _isSearching ? TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email',hintStyle: TextStyle(fontSize: 18,letterSpacing: 1)
                ),
                onChanged: (value){
                  searchList.clear();
                  for(var i in list){
                    if(i.name.toLowerCase().contains(value.toLowerCase()) || i.email.toLowerCase().contains(value.toLowerCase())){
                      searchList.add(i);
                    };
                    setState(() {
                      searchList;
                    });
                  }
                },
                autofocus: true,
              ) : Text(
                "Let's Chat",
                style: TextStyle(
                    color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
              ),
              actions: [
                IconButton(onPressed: () {
                  setState(() {
                    _isSearching=!_isSearching;
                  });
                }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid: Icons.search)),
                IconButton(onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfileScreen(user: API.me)));
                }, icon: const Icon(Icons.more_vert))
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 20),
              child: FloatingActionButton(
                onPressed: (){},
                child: Icon(Icons.add_comment_rounded),
              ),
            ),
            body: StreamBuilder(
                stream: API.getAllUsers(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        list=data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                      if(list.isNotEmpty){
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return ChatUserCard(user: _isSearching ? searchList[index]:  list[index],);
                          },
                          itemCount: _isSearching ? searchList.length : list.length,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(top: mq.height * .01),
                        );
                      }
                      else{
                        return Center(child: Text("No Connections Found!!",style: TextStyle(fontSize: 20),));
                      }
                  }
                })),
      ),
    );
  }
}
