import 'package:ECompany/constans_keys/const_keys.dart';
import 'package:ECompany/constant_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ECompany/Screens/ForgetPass/forget_screen.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';
import '../../ForgetPass/forget_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  late TextEditingController _emailTextController =
      TextEditingController(text: '');
  late TextEditingController _passTextController =
      TextEditingController(text: '');

  final _loginFormKey = GlobalKey<FormState>();
  FocusNode _passFocusNode = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  void submitFormOnLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = false;
      });
      try {
        await _auth.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        Navigator.canPop(context) ? Navigator.pop(context) : null;

      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        DialogGlobal.errorDialog(
            error: error.toString(), context: context);
      }
    } else {
      print('Form not valid');
    }
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          TextFormField(
            key: ConstKey.LEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_passFocusNode),
            validator: (value) {
              if (value!.isEmpty || !value.contains('@')) {
                return 'Please enter a valid Email adress';
              }
              return null;
            },
            controller: _emailTextController,
            decoration: InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              key: ConstKey.LPasword,
              onEditingComplete: submitFormOnLogin,
              focusNode: _passFocusNode,
              validator: (value) {
                if (value!.isEmpty || value.length < 7) {
                  return 'Please enter a valid password';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              controller: _passTextController,
              decoration: InputDecoration(
                hintText: "Your Password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 0,
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ForgetScreen();
                    },
                  ),
                );
              },
              child: Text(
                "Forget Password?",
                style: TextStyle(color: Color(0xFF407bff)),
              )),
          const SizedBox(height: defaultPadding),
          _isLoading
              ? Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Hero(
            key: ConstKey.LoginBtn,
                  tag: "login_btn",
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Login".toUpperCase(),
                    ),
                  ),
                ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}
