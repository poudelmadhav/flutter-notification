import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notify_me/model/message.dart';

class MessagingWidget extends StatefulWidget {
  MessagingWidget({Key key, this.context}) : super(key: key);

  final BuildContext context;

  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];


  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];

        setState(() {
          messages.add(
            Message(
              title: notification['title'],
              body: notification['body'],
            ),
          );
          _showConfirmDialogBox(widget.context, notification['title'], notification['body']);
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final notification = message['data'];

        setState(() {
          messages.add(
            Message(
              title: notification['title'],
              body: notification['body'],
            ),
          );
          _showConfirmDialogBox(widget.context, notification['title'], notification['body']);
        });
      },
      onResume: (Map<String, dynamic> message) async {
        final notification = message['data'];

        setState(() {
          messages.add(
            Message(
              title: notification['title'],
              body: notification['body'],
            ),
          );
          _showConfirmDialogBox(widget.context, notification['title'], notification['body']);
        });
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: messages.map(buildMessage).toList(),
      ),
    );
  }

  Widget buildMessage(Message message) {
    return ListTile(
      title: Text(message.title),
      subtitle: Text(message.body),
    );
  }

  void _showConfirmDialogBox(BuildContext context, String title, String body) {
    /// Here we can use CupertinoAlertDialog instead of AlertDialog for iPhone style dialog
    /// But we need to import 'package:flutter/cupertino.dart';
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Ok'),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
