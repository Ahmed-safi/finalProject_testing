import 'package:ECompany/Screens/Employees/employees_list.dart';
import 'package:ECompany/Screens/Home/components/list_drow.dart';
import 'package:ECompany/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmployeesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ListDrwer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        title: Text(
          'All Employees',
          style: TextStyle(color: kPrimaryColor),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                    return EmployeesListWidget(
                    userID: snapshot.data!.docs[index]['id'],
                    userName: snapshot.data!.docs[index]['name'],
                    userEmail: snapshot.data!.docs[index]['email'],
                    positionInCompany: snapshot.data!.docs[index]['positionCompany'],
                    phoneNumber: snapshot.data!.docs[index]['phoneNumber'],
                    userImageUrl: snapshot.data!.docs[index]['avatarImage'],
                    );
                  });
            } else {
              return Center(
                child: Text('No user found'),
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
}
