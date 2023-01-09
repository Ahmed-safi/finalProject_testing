import 'package:ECompany/Screens/Home/components/list_drow.dart';
import 'package:ECompany/constant_dialog.dart';
import 'package:ECompany/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../../constans_keys/const_keys.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _categoryController =
      TextEditingController(text: 'Task Category');
  TextEditingController _titleController = TextEditingController(text: '');
  TextEditingController _descriptionController =
      TextEditingController(text: '');
  TextEditingController _deadlineDateController =
      TextEditingController(text: 'pick up a date');
  final _uploadFormKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? _deadlineDateTimeStamp;
  bool _isLoading = false;

  void dispose() {
    super.dispose();
    _categoryController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineDateController.dispose();
  }

  void upload() async {
    User? user = _auth.currentUser;
    String _uid = user!.uid;
    final isValid = _uploadFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (_deadlineDateController.text == 'pick up a date' ||
          _categoryController.text == 'Task Category') {
        DialogGlobal.errorDialog(
            error: 'Please pick up everything', context: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      final taskID = Uuid().v4();
      try {
        await FirebaseFirestore.instance.collection('tasks').doc(taskID).set({
          'taskId': taskID,
          'uploadedBy': _uid,
          'taskTitle': _titleController.text,
          'taskDescription': _descriptionController.text,
          'deadlineDate': _deadlineDateController.text,
          'deadlineDateTimeStamp': _deadlineDateTimeStamp,
          'taskCategory': _categoryController.text,
          'taskComments': [],
          'isDone': false,
          'createdAt': Timestamp.now(),
        });
        Fluttertoast.showToast(
            msg: "Task has been uploaded successfuly",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: kPrimaryLightColor,
            textColor: kPrimaryDarkColor,
            fontSize: 16.0);
        _descriptionController.clear();
        _titleController.clear();
        setState(() {
          _categoryController.text = 'Task Category';
          _deadlineDateController.text = 'pick up a date';
        });
      } catch (error) {
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('Form not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        backgroundColor: Color(0x9b82a9ff),
        elevation: 1,
      ),
      drawer: ListDrwer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Requirements',
                      style: TextStyle(
                          fontSize: 25,
                          color: kPrimaryDarkColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Form(
                    key: _uploadFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        textsWidget(textLabel: 'Category *'),
                        _formFields(
                            valueKey: 'Category',
                            controller: _categoryController,
                            enabled: false,
                            fct: () {
                              ConstKey.Category;
                              showTaskCategory(size);
                            },
                            maxLength: 100),
                        textsWidget(textLabel: 'Title *'),
                        _formFields(
                            valueKey: 'Title',
                            controller: _titleController,
                            enabled: true,
                            fct: () {
                              ConstKey.Title;
                            },
                            maxLength: 100),
                        textsWidget(textLabel: 'Description *'),
                        _formFields(
                            valueKey: 'TaskDescription',
                            controller: _descriptionController,
                            enabled: true,
                            fct: () {
                              ConstKey.Description;
                            },
                            maxLength: 500),
                        textsWidget(textLabel: 'Deadline *'),
                        _formFields(
                            valueKey: 'Deadline',
                            controller: _deadlineDateController,
                            enabled: false,
                            fct: () {
                              ConstKey.Deadline;
                              _pickDate();
                            },
                            maxLength: 100),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                          child: _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                            key: ConstKey.uploadBtn,
                                  onPressed: upload,
                                  child: Text(
                                    "upload".toUpperCase(),
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showTaskCategory(size) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Task category',
              style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tasksCateg.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _categoryController.text = tasksCateg[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_box_outlined,
                            color: kPrimaryLightColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tasksCateg[index],
                              style: TextStyle(
                                color: kPrimaryDarkColor,
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text('Close'),
              ),
            ],
          );
        });
  }

  void _pickDate() async {
    picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 0)),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        _deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
        _deadlineDateController.text =
            '${picked!.year}-${picked!.month}-${picked!.day}';
      });
    }
  }

  textsWidget({String? textLabel}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        textLabel!,
        style: TextStyle(
            fontSize: 20, color: kPrimaryColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  _formFields(
      {required String valueKey,
      required TextEditingController controller,
      required bool enabled,
      required Function fct,
      required int maxLength}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          //key: ConstKey.Title,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return 'oooh, not valid';
            }
            return null;
          },
          enabled: enabled,
          key: ValueKey(valueKey),
          style: TextStyle(
            color: kPrimaryDarkColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          maxLines: valueKey == 'TaskDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0x9b82a9ff),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
            ),
            // focusedErrorBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.red),
            // )
          ),
        ),
      ),
    );
  }
}
