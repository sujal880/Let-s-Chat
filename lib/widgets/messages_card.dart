import 'package:flutter/material.dart';
import 'package:letschat/models/message_model.dart';
import 'package:letschat/uihelper/mydateutil.dart';

import '../api/api.dart';
import '../main.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  MessageCard({Key? key, required this.message}) : super(key: key);

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: API.user.uid == widget.message.fromid
            ? _greenMessage()
            : _blueMessage());
  }

  _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.done_all_rounded,color: Colors.blue,size: 20,),
        if(widget.message.read.isNotEmpty)
        Padding(
          padding: EdgeInsets.only(right: mq.width*.5),
          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),style: TextStyle(fontSize: 13,color: Colors.black54),),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            padding: EdgeInsets.all(mq.width * .04),
            decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),border: Border.all(
                color: Colors.lightGreen
            )),
            child: Text(
              widget.message.msg,
              style: TextStyle(color: Colors.black87, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            padding: EdgeInsets.all(mq.width * .04),
            decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)),border: Border.all(
              color: Colors.lightBlue
            )),
            child: Text(
              widget.message.msg,
              style: TextStyle(color: Colors.black87, fontSize: 15),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width*.04),
          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),style: TextStyle(fontSize: 13,color: Colors.black54),),
        ),
      ],
    );
  }
}
