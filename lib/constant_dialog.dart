import 'package:ECompany/constants.dart';
import 'package:flutter/material.dart';
class DialogGlobal{
  static void errorDialog(
      {required String error, required BuildContext context}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Align(alignment:Alignment.center, child: Text('Error!')),
                ),
              ],
            ),
            content: Text(
              error,
              style: TextStyle(
                color: kPrimaryDarkColor,
                fontSize: 20,),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text('OK', style: TextStyle(color: Colors.red),))
            ],
          );
        });
  }

}