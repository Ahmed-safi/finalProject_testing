import 'package:ECompany/Screens/Home/components/home_widget.dart';
import 'package:ECompany/Screens/Home/components/list_drow.dart';
import 'package:ECompany/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? taskCat;
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: ListDrwer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        // leading: Builder(
        //   builder: (ctx) {
        //     return IconButton(
        //       icon: Icon(
        //         Icons.menu,
        //         color: Colors.red,
        //       ),
        //       onPressed: () {
        //         Scaffold.of(ctx).openDrawer();
        //       },
        //     );
        //   },
        // ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        title: Text(
          'Tasks',
          style: TextStyle(color: kPrimaryColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showTaskCategory(context, size);
            },
            icon: Icon(
              Icons.filter_list_outlined,
              color: kPrimaryLightColor,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('taskCategory', isEqualTo: taskCat)
          //  .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return HomeWidget(
                      taskTitle: snapshot.data!.docs[index]['taskTitle'],
                      taskDescription: snapshot.data!.docs[index]['taskDescription'],
                      taskId: snapshot.data!.docs[index]['taskId'],
                      uploadedBy: snapshot.data!.docs[index]['uploadedBy'],
                      isDone: snapshot.data!.docs[index]['isDone'],
                    );
                  });
            } else {
              return Center(
                child: Text('No Tasks found'),
              );
            }
          }
          return Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }

  void showTaskCategory(context, size) {
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
                        print("tasks Category ${tasksCateg[index]}");
                        setState(() {
                          taskCat = tasksCateg[index];
                        });
                        Navigator.canPop(context) ? Navigator.pop(context) : null;
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
              TextButton(
                  onPressed: () {
                    setState(() {
                      taskCat = null;
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text('Cancel filter'))
            ],
          );
        });
  }
}
