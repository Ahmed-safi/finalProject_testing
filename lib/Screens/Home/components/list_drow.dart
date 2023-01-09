import 'package:ECompany/Screens/AddTask/add_task_screen.dart';
import 'package:ECompany/Screens/Employees/employees.dart';
import 'package:ECompany/Screens/Home/home_screen.dart';
import 'package:ECompany/Screens/Login/login_screen.dart';
import 'package:ECompany/Screens/Profile/profil_screen.dart';
import 'package:ECompany/constants.dart';
import 'package:ECompany/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListDrwer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
        child: ListView(
      children: [
         DrawerHeader(
            decoration: BoxDecoration(color: kPrimaryLightColor),
            child: Column(
              children: [
                Positioned(
                  // right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.20,
                        height: size.width * 0.20,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: kPrimaryDarkColor),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/icons/logo.png',),
                                fit: BoxFit.fill)),
                      )
                    ],
                  ),
                ),
               // Flexible(child: Image.asset('assets/icons/logoProfile.png')),
                SizedBox(
                  height: 16,
                ),
                Flexible(
                    child: Text(
                  'Create By Ahmed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryDarkColor,
                    fontSize: 15,
                  ),
                ))
              ],
            )),
          SizedBox(
          height: 30,
        ),
          _listTile(
            label: 'All tasks',
            fct: () {_navigateToTaskScreen(context);},
            icon: Icons.business_center_outlined),
          _listTile(
            label: 'My account',
            fct: () {_navigateToProfileScreen(context);},
            icon: Icons.person_outline),
         _listTile(
            label: 'Employees',
            fct: () {_navigateToEmployeesScreen(context);},
            icon: Icons.workspaces_outline),
          _listTile(label: 'Add task',
              fct: () {_navigateToAddTaskScreen(context);},
              icon: Icons.add_box_outlined),
         Divider(
          thickness: 1,
        ),
         _listTile(label: 'Log out',
              fct: () { _logout(context);},
              icon: Icons.logout_outlined),
      ],
    ));
  }
  void _navigateToTaskScreen(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }
  void _navigateToProfileScreen(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(userID:uid,),
      ),
    );
  }
  void _navigateToAddTaskScreen(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(),
      ),
    );
  }
  void _navigateToEmployeesScreen(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeesScreen(),
      ),
    );
  }
  void _out(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UserState(),
      ),
    );
  }
  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text('Sign out'),
                ),
              ],
            ),
            content: Text(
              'are you sure about that',
              style: TextStyle(
                  color: kPrimaryDarkColor,
                  fontSize: 20,),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text('Cancel'),
              ),
              TextButton(
                  onPressed: () async {
                   await _auth.signOut();
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    _out(context);
                  },
                  child: Text('OK', style: TextStyle(color: Colors.red),))
            ],
          );
        });
  }
  Widget _listTile(
      {required String label, required Function fct, required IconData icon}) {
    return ListTile(
      onTap: () {
        fct();
      },
      leading: Icon(
        icon,
        color: kPrimaryDarkColor,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: kPrimaryDarkColor,
          fontSize: 20,
        ),
      ),
    );
  }
}
