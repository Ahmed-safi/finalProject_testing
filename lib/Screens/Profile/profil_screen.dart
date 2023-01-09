import 'package:ECompany/Screens/Home/components/list_drow.dart';
import 'package:ECompany/Screens/Login/login_screen.dart';
import 'package:ECompany/constant_dialog.dart';
import 'package:ECompany/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final String userID;

  const ProfileScreen({required this.userID});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String phoneNumber = "";
  String email = "";
  String name = "";
  String job = "";
  String? imageUrl;
  String joinedAt = "";
  bool _isSameUser = false;

  @override
  void initState() {
    super.initState();
    getUserDate();
  }

  void getUserDate() async {
    _isLoading = true;
    print('uid ${widget.userID}');
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();

      if (userDoc == null) {
        return;
      } else {
        setState(() {
          email = userDoc.get('email');
          name = userDoc.get('name');
          phoneNumber = userDoc.get('phoneNumber');
          job = userDoc.get('positionCompany');
          imageUrl = userDoc.get('avatarImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
        });
        User? user = _auth.currentUser;
        String _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
        print('_isSameUser $_isSameUser');
      }
    } catch (error) {
      DialogGlobal.errorDialog(error: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: ListDrwer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: kPrimaryColor),
          backgroundColor: kPrimaryLightColor,
          elevation: 0,
        ),
        backgroundColor: kPrimaryLightColor,
        body: _isLoading
            ? Center(
                child: Text(
                  'Fetching data',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 115),
                  child: Center(
                    child: Stack(
                      children: [
                        Card(
                          margin: EdgeInsets.all(30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 70,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    name == null ? "" : name,
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$job Since join $joinedAt',
                                    style: TextStyle(
                                      color: kPrimaryLightColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "contact",
                                    style: TextStyle(
                                      color: kPrimaryDarkColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                contactDitils(text: 'Email:', contact: email),
                                SizedBox(
                                  height: 10,
                                ),
                                contactDitils(
                                    text: 'Phone number:',
                                    contact: phoneNumber),
                                SizedBox(
                                  height: 20,
                                ),
                                _isSameUser
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          socialBtn(
                                              color: Colors.green,
                                              icon: Icons.whatsapp_outlined,
                                              fct: () {
                                                _openWhatsAppChat();
                                              }),
                                          socialBtn(
                                              color: Colors.red,
                                              icon: Icons.mail_outline_outlined,
                                              fct: () {
                                                _mail();
                                              }),
                                          socialBtn(
                                              color: Colors.green,
                                              icon: Icons.call_outlined,
                                              fct: () {
                                                _PhoneNumber();
                                              }),
                                        ],
                                      ),
                                SizedBox(
                                  height: 20,
                                ),
                                _isSameUser
                                    ? Container()
                                    : Divider(
                                        thickness: 1,
                                      ),
                                SizedBox(
                                  height: 20,
                                ),
                                !_isSameUser
                                    ? Container()
                                    : Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0, left: 8.0),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              await _auth.signOut();
                                              Navigator.canPop(context)
                                                  ? Navigator.pop(context)
                                                  : null;
                                              _out(context);
                                            },
                                            child: Text(
                                              "Log out".toUpperCase(),
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          // right: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: size.width * 0.26,
                                height: size.width * 0.26,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: kPrimaryLightColor),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(
                                          imageUrl == null
                                              ? 'assets/icons/logoProfile.png'
                                              : imageUrl!,
                                        ),
                                        fit: BoxFit.fill)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }

  void _openWhatsAppChat() async {
    var whatsappUrl = 'https://wa.me/$phoneNumber';
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Error occured coulnd\'t open link';
    }
  }

  void _mail() async {
    var url = 'mail:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error occured coulnd\'t open link';
    }
  }

  void _PhoneNumber() async {
    var phoneUrl = 'tel://$phoneNumber';
    if (await canLaunch(phoneUrl)) {
      launch(phoneUrl);
    } else {
      throw "Error occured coulnd\'t open link";
    }
  }

  Widget contactDitils({required String text, required String contact}) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            color: kPrimaryDarkColor,
            fontSize: 16,
            fontStyle: FontStyle.normal,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            contact,
            style: TextStyle(
              color: kPrimaryLightColor,
              fontSize: 14,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget socialBtn(
      {required Color color, required IconData icon, required Function fct}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(
            icon,
            color: color,
          ),
          onPressed: () {
            fct();
          },
        ),
      ),
    );
  }

  void _out(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
}
