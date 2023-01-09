import 'package:ECompany/Screens/Profile/profil_screen.dart';
import 'package:ECompany/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeesListWidget extends StatefulWidget {
  final String userID;
  final String userName;
  final String userEmail;
  final String positionInCompany;
  final String phoneNumber;
  final String userImageUrl;

  const EmployeesListWidget(
      {required this.userID,
      required this.userName,
      required this.userEmail,
      required this.positionInCompany,
      required this.phoneNumber,
      required this.userImageUrl});

  @override
  _EmployeesListWidgetState createState() => _EmployeesListWidgetState();
}

class _EmployeesListWidgetState extends State<EmployeesListWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => ProfileScreen(userID:widget.userID,),
            ),
            );
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: Container(
            child: (Container(
              width: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(widget.userImageUrl == null
                          ? 'assets/icons/logoProfile.png'
                          : widget.userImageUrl),
                      fit: BoxFit.cover)),
            )),
          ),
          title: Text(
            widget.userName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.linear_scale,
                color: kPrimaryColor,
              ),
              Text(
                '${widget.positionInCompany}/${widget.phoneNumber}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.mail_outlined,
              size: 30,
              color: kPrimaryColor,
            ),
            onPressed: _mail,
          )),
    );
  }

  void _mail() async {
    print('widget.userEmail ${widget.userEmail}');
    var url = 'mailto:${widget.userEmail}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error occured coulnd\'t open link';
    }
  }
}
