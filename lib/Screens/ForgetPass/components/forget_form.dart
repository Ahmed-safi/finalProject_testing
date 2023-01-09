import 'package:ECompany/constans_keys/const_keys.dart';

import 'package:flutter/material.dart';

import '../../../../components/already_have_an_account_acheck.dart';
import '../../../../constants.dart';

class ForgetPasswor extends StatelessWidget {
  const ForgetPasswor({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              key: ConstKey.FEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            Hero(
              key: ConstKey.FrgtBtn,
              tag: "login_btn",
              child: ElevatedButton(
                onPressed: () {
                  print("object");
                },
                child: Text(
                  "Rest".toUpperCase(),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
