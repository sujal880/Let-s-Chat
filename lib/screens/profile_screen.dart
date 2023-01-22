import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../api/api.dart';
import '../main.dart';
import '../models/chatroommodel.dart';
import '../uihelper/dialogs.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Profile Screen"),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            onPressed: () async {
              Dialogs.showProgressBar(context);
              await API.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                });
              });
            },
            icon: Icon(Icons.logout),
            backgroundColor: Colors.red,
            label: Text("Log Out"),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: mq.height * .04),
              Center(
                child: Stack(children: [
                  _image!=null ? ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: Image.file(
                      height: mq.height*.2,
                      width: mq.height*.2,
                      File(_image!),fit: BoxFit.cover,
                    )
                  ) :
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      height: mq.height * .2,
                      width: mq.height * .2,
                      imageUrl: widget.user.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Dialogs.AnimationIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )
                  ,
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                          onPressed: () {
                            _showbottomSheet();
                          },
                          color: Colors.white,
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          shape: CircleBorder(),
                          elevation: 1))
                ]),
              ),
              SizedBox(height: mq.height * .03),
              Text("${widget.user.email}",
                  style: TextStyle(fontSize: 18, color: Colors.black54)),
              SizedBox(height: mq.height * .02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  onSaved: (value) => API.me.name = value ?? '',
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : "Required Field",
                  initialValue: widget.user.name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      hintText: "eg. John",
                      label: Text("Name"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      )),
                ),
              ),
              SizedBox(
                height: mq.height * .02,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  onSaved: (value) => API.me.about = value ?? '',
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : "Required Field",
                  initialValue: widget.user.about,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                      ),
                      hintText: "eg. Feeling Happy",
                      label: Text("About"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      )),
                ),
              ),
              SizedBox(height: mq.height * .07),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    API.updateUserInfo().then((value) {
                      Dialogs.showSnackbar(context, "Profile Updated");
                    });
                  }
                },
                child: Text(
                  "UPDATE",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    minimumSize: Size(mq.width * .5, mq.height * .055)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showbottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              Text(
                "Pick Profile Picture",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: mq.height*.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: ()async{
                        final ImagePicker _picker = ImagePicker();
                        // Pick an image
                        final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                        if(image!=null){
                          log("Image Path: ${image.path}");
                          setState(() {
                            _image=image.path;
                          });
                          API.updateProfilePictures(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(shape: CircleBorder(),backgroundColor: Colors.white,
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      child: Image.asset('images/camera.png')),
                  ElevatedButton(
                      onPressed: ()async{
                        final ImagePicker _picker = ImagePicker();
                        // Pick an image
                        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                        if(image!=null){
                          log("Image Path: ${image.path}");
                          setState(() {
                            _image=image.path;
                          });
                          API.updateProfilePictures(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(shape: CircleBorder(),backgroundColor: Colors.white,
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      child: Image.asset('images/image.png'))
                ],
              ),
              SizedBox(height: mq.height*.02,)
            ],
          );
        });
  }
}
