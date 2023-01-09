import 'dart:io';

import 'package:ECompany/constans_keys/const_keys.dart';
import 'package:ECompany/constant_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> with TickerProviderStateMixin {
  late TextEditingController _fullnameController =
      TextEditingController(text: '');
  late TextEditingController _emailController = TextEditingController(text: '');
  late TextEditingController _passController = TextEditingController(text: '');
  late TextEditingController _phoneController = TextEditingController(text: '');
  late TextEditingController _positionCPController = TextEditingController(text: '');

  FocusNode _fullnameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _positionFocusNode = FocusNode();
  File? imageFile;
  final _signUpFormKey = GlobalKey<FormState>();

  //firebase---------------------
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? url;

  //firebase---------------------
  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _phoneController.dispose();
    _positionCPController.dispose();
    _fullnameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _positionFocusNode.dispose();
    _phoneFocusNode.dispose();

    super.dispose();
  }

  void submitFormOnSignUp() async {
    final isValid = _signUpFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (imageFile == null){
        DialogGlobal.errorDialog(error: 'please add image', context: context);
        return;
      }
      setState(() {
        _isLoading = false;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.toLowerCase().trim(),
            password: _passController.text.trim());

       final User? user = _auth.currentUser;
       final _uid = user!.uid;
       final ref = FirebaseStorage.instance.ref().child('avatarImages').child(_uid + 'jpg');
       await ref.putFile(imageFile!);
       url = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _fullnameController.text,
          'email': _emailController.text,
          'password': _passController.text,
          'phoneNumber': _phoneController.text,
          'positionCompany': _positionCPController.text,
          'avatarImage': url,
          'createAt': Timestamp.now(),
        });
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        DialogGlobal.errorDialog(
            error: error.toString(), context: context);
        print('is error $error');
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
    Size size = MediaQuery.of(context).size;
    return (Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 2,
                child: TextFormField(
                  key: ConstKey.FName,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  onSaved: (fullname) {},
                  focusNode: _fullnameFocusNode,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_emailFocusNode),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field can\'t be missing';
                    }
                    return null;
                  },
                  controller: _fullnameController,
                  decoration: InputDecoration(
                    hintText: "Full Name",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.add_box),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Stack(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 20, bottom: 0),
                      child: Container(
                        width: size.width * 0.20,
                        height: size.height * 0.10,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 2, color: kPrimaryLightColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: imageFile == null
                              ? Image.network(
                                  'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
                                  fit: BoxFit.fill,
                                )
                              : Image.file(
                                  imageFile!,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _showImageDialog,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 2, color: kPrimaryColor),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              imageFile == null
                                  ? Icons.add_a_photo
                                  : Icons.edit_outlined,
                              size: 16,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              key: ConstKey.Email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              focusNode: _emailFocusNode,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_passFocusNode),
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid Email address';
                }
                return null;
              },
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Enter Email",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          TextFormField(
            key: ConstKey.Pasword,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: kPrimaryColor,
            onSaved: (password) {},
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_phoneFocusNode),
            validator: (value) {
              if (value!.isEmpty || value.length < 7) {
                return 'Please enter a valid password';
              }
              return null;
            },
            controller: _passController,
            decoration: InputDecoration(
              hintText: "Enter Password",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.lock),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              key: ConstKey.PhonN,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (Phone) {},
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_positionFocusNode),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Field can\'t be missing';
                }
                return null;
              },
              onChanged: (v) {
                print('Phone Text: ${_phoneController.text}');
              },
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: "Phone Number",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.call),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => showCompanyPositions(size),
            child: TextFormField(
              key: ConstKey.Position,
              enabled: false,
              cursorColor: kPrimaryColor,
              onSaved: (position) {},
              onEditingComplete: submitFormOnSignUp,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Field can\'t be missing';
                }
                return null;
              },
              controller: _positionCPController,
              decoration: InputDecoration(
                hintText: "Company Position",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.business_center_rounded),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          _isLoading
              ? Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                )
              : ElevatedButton(
                  key: ConstKey.SinupBtn,
                  onPressed: submitFormOnSignUp,
                  child: Text("Sign Up".toUpperCase()),
                ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    ));
  }

  void showCompanyPositions(size) {
    showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AlertDialog(
              title: Text(
                'Company Position',
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              content: Container(
                width: size.width * 0.9,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: jobsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _positionCPController.text = jobsList[index];
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
                                jobsList[index],
                                style: TextStyle(
                                  color: kPrimaryDarkColor,
                                  fontSize: 15,
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
            ),
          );
        });
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Please choose an option',
              style: TextStyle(color: kPrimaryDarkColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: _pickImageWithCamera,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: kPrimaryColor,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          'Camera',
                          style: TextStyle(color: kPrimaryLightColor),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: _pickImageWithGallery,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.image,
                          color: kPrimaryColor,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          'Gallery',
                          style: TextStyle(color: kPrimaryLightColor),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _pickImageWithCamera() async {
    try{PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, maxWidth: 1080, maxHeight: 1080);}
    catch (error){
      DialogGlobal.errorDialog(error: '$error', context: context);
    }

    /*setState(() {
      imageFile = File(pickedFile!.path);
    });*/

    Navigator.pop(context);
  }

  void _pickImageWithGallery() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxWidth: 1080, maxHeight: 1080);

    setState(() {
      imageFile = File(pickedFile!.path);
    });

    Navigator.pop(context);
  }
}
