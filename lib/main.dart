import 'package:ECompany/Screens/AddTask/add_task_screen.dart';
import 'package:ECompany/Screens/Employees/employees.dart';
import 'package:ECompany/Screens/Home/home_screen.dart';
import 'package:ECompany/Screens/Signup/signup_screen.dart';
import 'package:ECompany/Screens/TaskDetails/details_task.dart';
import 'package:ECompany/users.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ECompany/Screens/Welcome/welcome_screen.dart';
import 'package:ECompany/constants.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _appInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _appInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text(
                    'App is loading',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                  ),
                ),
              ),
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ECompany',
            theme: ThemeData(
                primaryColor: kPrimaryColor,
                scaffoldBackgroundColor: Colors.white,
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: kPrimaryColor,
                    shape: const StadiumBorder(),
                    maximumSize: const Size(double.infinity, 56),
                    minimumSize: const Size(double.infinity, 56),
                  ),
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  fillColor: kPrimaryLightColor,
                  iconColor: kPrimaryColor,
                  prefixIconColor: kPrimaryColor,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide.none,
                  ),
                )),
            home: /*SignUpScreenEmployeesScreenAddTaskScreenTaskDetailsScreenHomeScreen()UserState()*/UserState(),
          );
        }
    );

  }
}
