import 'package:ECompany/Screens/TaskDetails/details_task.dart';
import 'package:ECompany/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constant_dialog.dart';

class HomeWidget extends StatefulWidget {
  final String taskTitle;
  final String taskDescription;
  final String taskId;
  final String uploadedBy;
  final bool isDone;

  const HomeWidget(
      {required this.taskTitle,
      required this.taskDescription,
      required this.taskId,
      required this.uploadedBy,
      required this.isDone});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailsScreen(
                taskId: widget.taskId,
                uploadedBy: widget.uploadedBy,
              ),
            ),
          );
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actions: [
                    TextButton(
                        onPressed: () {
                          User? user = _auth.currentUser;
                          String _uid = user!.uid;
                          if (_uid == widget.uploadedBy) {
                            FirebaseFirestore.instance
                                .collection('tasks')
                                .doc(widget.taskId)
                                .delete();
                            Navigator.pop(context);
                          } else {
                            DialogGlobal.errorDialog(
                                error:
                                    'You dont have access to delete this task',
                                context: context);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          ],
                        ))
                  ],
                );
              });
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0),
            ),
          ),
          child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20,
              child: Image.asset(widget.isDone
                  ? 'assets/icons/tick.png'
                  : 'assets/icons/alarm-clock.png')),
        ),
        title: Text(
          widget.taskTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale,
              color: kPrimaryColor,
            ),
            Text(
              widget.taskDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}
