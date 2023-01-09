import 'package:ECompany/Screens/TaskDetails/comment_widget.dart';
import 'package:ECompany/constans_keys/const_keys.dart';
import 'package:ECompany/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../../constant_dialog.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;
  final String uploadedBy;

  const TaskDetailsScreen({required this.taskId, required this.uploadedBy});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _authorName;
  String? _authorPosition;
  String? taskDescription;
  String? taskTitle;
  bool? _isDone;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? deadlineDate;
  String? postedDate;
  String? userImageUrl;
  bool isDeadlineAvailable = false;
  bool _isLoading = false;
  bool _isCommenting = false;
  TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uploadedBy)
          .get();
      if (userDoc == null) {
        return;
      } else {
        setState(() {
          _authorName = userDoc.get('name');
          _authorPosition = userDoc.get('positionCompany');
          userImageUrl = userDoc.get('avatarImage');
        });
      }

      final DocumentSnapshot taskDatabase = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .get();
      if (taskDatabase == null) {
        return;
      } else {
        setState(() {
          taskDescription = taskDatabase.get('taskDescription');
          _isDone = taskDatabase.get('isDone');
          deadlineDate = taskDatabase.get('deadlineDate');
          deadlineDateTimeStamp = taskDatabase.get('deadlineDateTimeStamp');
          postedDateTimeStamp = taskDatabase.get('createdAt');
          var postDate = postedDateTimeStamp!.toDate();
          postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
          var date = deadlineDateTimeStamp!.toDate();
          isDeadlineAvailable = date.isAfter(DateTime.now());
        });
      }
    } catch (error) {
      DialogGlobal.errorDialog(error: 'An error occured', context: context);
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: kPrimaryColor,
          iconSize: 25,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(
              child: Text(
                'Fetching data',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        taskTitle == null ? '' : taskTitle!,
                        style: TextStyle(
                            color: kPrimaryDarkColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Upload By",
                                    style: TextStyle(
                                        color: kPrimaryDarkColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                        color: kPrimaryColor,
                                      ),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                            userImageUrl == null
                                                ? 'assets/icons/avatar.png'
                                                : userImageUrl!,
                                          ),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _authorName == null ? '' : _authorName!,
                                        style: TextStyle(
                                          color: kPrimaryDarkColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        _authorPosition == null
                                            ? ''
                                            : _authorPosition!,
                                        style: TextStyle(
                                          color: kPrimaryDarkColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Divider(
                      thickness: 1,
                      color: kPrimaryDarkColor,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Uploaded on:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: kPrimaryDarkColor),
                                  ),
                                  Text(
                                    postedDate == null ? '' : postedDate!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: kPrimaryDarkColor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Deadline date:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: kPrimaryDarkColor),
                                  ),
                                  Text(
                                    deadlineDate == null ? '' : deadlineDate!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  isDeadlineAvailable
                                      ? 'Still have enough time'
                                      : "No time left",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: isDeadlineAvailable
                                          ? Colors.green
                                          : Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Divider(
                      thickness: 1,
                      color: kPrimaryDarkColor,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                      child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Task state:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: kPrimaryDarkColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: TextButton(
                                        child: Text('Done',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15,
                                                color: kPrimaryDarkColor)),
                                        onPressed: () {
                                          User? user = _auth.currentUser;
                                          String _uid = user!.uid;
                                          if (_uid == widget.uploadedBy) {
                                            FirebaseFirestore.instance
                                                .collection('tasks')
                                                .doc(widget.taskId)
                                                .update({'isDone': true});
                                            getData();
                                          } else {
                                            DialogGlobal.errorDialog(
                                                error:
                                                    'You can\'t perform this action',
                                                context: context);
                                          }
                                        },
                                      ),
                                    ),
                                    Opacity(
                                      opacity: _isDone == true ? 1 : 0,
                                      child: Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Flexible(
                                      child: TextButton(
                                        child: Text('Not done',
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15,
                                              color: kPrimaryDarkColor,
                                            )),
                                        onPressed: () {
                                          User? user = _auth.currentUser;
                                          String _uid = user!.uid;
                                          if (_uid == widget.uploadedBy) {
                                            FirebaseFirestore.instance
                                                .collection('tasks')
                                                .doc(widget.taskId)
                                                .update({'isDone': false});
                                            getData();
                                          } else {
                                            DialogGlobal.errorDialog(
                                                error:
                                                    'You can\'t perform this action',
                                                context: context);
                                          }
                                        },
                                      ),
                                    ),
                                    Opacity(
                                      opacity: _isDone == false ? 1 : 0,
                                      child: Icon(
                                        Icons.dangerous_outlined,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ])))),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Divider(
                      thickness: 1,
                      color: kPrimaryDarkColor,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 8, left: 8),
                      child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Task description:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: kPrimaryDarkColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      taskDescription == null
                                          ? ''
                                          : taskDescription!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: kPrimaryDarkColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ])))),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Divider(
                      thickness: 1,
                      color: kPrimaryDarkColor,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 8, left: 8),
                      child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                AnimatedSwitcher(
                                  duration: Duration(milliseconds: 500),
                                  child: _isCommenting
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Flexible(
                                              flex: 3,
                                              child: TextField(
                                                maxLength: 200,
                                                controller: _commentController,
                                                style: TextStyle(
                                                  color: kPrimaryDarkColor,
                                                ),
                                                keyboardType:
                                                    TextInputType.text,
                                                maxLines: 6,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Color(0xffc7dbff),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white),
                                                  ),
                                                  errorBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: kPrimaryColor),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            ),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MaterialButton(
                                              key: ConstKey.Comment,
                                              onPressed: () async {
                                                if (_commentController.text.length < 7) {
                                                  DialogGlobal.errorDialog(
                                                      error: 'Comment cant be less than 7 characteres',
                                                      context: context);
                                                } else {
                                                  final _generatedId = Uuid().v4();
                                                  await FirebaseFirestore.instance
                                                      .collection('tasks')
                                                      .doc(widget.taskId)
                                                      .update({'taskComments': FieldValue.arrayUnion([
                                                      {
                                                        'userId': widget.uploadedBy,
                                                        'commentId': _generatedId,
                                                        'name': _authorName,
                                                        'commentBody': _commentController.text,
                                                        'time': Timestamp.now(),
                                                        'userImageUrl': userImageUrl,
                                                      }
                                                    ]),
                                                  });
                                                  Fluttertoast.showToast(
                                                      msg: "Comment successfuly",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: kPrimaryLightColor,
                                                      textColor: kPrimaryDarkColor,
                                                      fontSize: 16.0);
                                                  _commentController.clear();
                                                  setState(() {});
                                                }
                                              },
                                              color: kPrimaryColor,
                                              elevation: 10,
                                              shape:
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(13),
                                                      side: BorderSide.none),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets
                                                            .symmetric(
                                                        vertical: 14),
                                                child: Text(
                                                  'Post'.toUpperCase(),
                                                  key: ConstKey.PostBtn,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      // fontSize: 20,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isCommenting = !_isCommenting;
                                                });
                                              },
                                              child: Text(
                                                  'Cancel'.toUpperCase(),
                                                  key: ConstKey.CanselBtn,
                                                  style: TextStyle(
                                                      color: kPrimaryColor)),
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              )
                                    : Center(
                                      child: MaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            _isCommenting = !_isCommenting;
                                          });
                                        },
                                        color: kPrimaryColor,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            side: BorderSide.none),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 14),
                                          child: Text(
                                            'Add comment'.toUpperCase(),
                                            key: ConstKey.CommentBtn,
                                            style: TextStyle(
                                                color: Colors.white,
                                                // fontSize: 20,
                                                fontWeight:
                                                    FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ])))),
                  SizedBox(
                    height: 30,
                  ),
                  FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(widget.taskId)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (snapshot.data == null) {
                            return Container();
                          }
                        }
                        return ListView.separated(
                            reverse: true,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              return CommentWidget(
                                commentId:
                                snapshot.data!['taskComments']
                                [index]['commentId'],
                                commentBody:
                                snapshot.data!['taskComments']
                                [index]['commentBody'],
                                commenterId:
                                snapshot.data!['taskComments']
                                [index]['userId'],
                                commenterName:
                                snapshot.data!['taskComments']
                                [index]['name'],
                                commenterImageUrl:
                                snapshot.data!['taskComments']
                                [index]['userImageUrl'],
                              );
                            },
                            separatorBuilder: (ctx, index) {
                              return Divider(
                                thickness: 1,
                              );
                            },
                            itemCount: snapshot
                                .data!['taskComments'].length);
                      })
                ],
              ),
            ),
    );
  }
}
