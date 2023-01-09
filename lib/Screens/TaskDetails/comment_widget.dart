import 'package:ECompany/Screens/Profile/profil_screen.dart';
import 'package:ECompany/constants.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  CommentWidget(
      {Key? key,
        required this.commentId,
        required this.commentBody,
        required this.commenterImageUrl,
        required this.commenterName,
        required this.commenterId});

  final String commentId;
  final String commentBody;
  final String commenterImageUrl;
  final String commenterName;
  final String commenterId;
  List<Color> _colors = [
    Color(0xFF407bff),
    Colors.orangeAccent,
    Colors.pink,
    Colors.amber,
    Colors.purple,
    Colors.brown,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(userID:commenterId,),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: _colors[3],
                  ),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(
                        commenterImageUrl,
                      ),
                      fit: BoxFit.fill),
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commenterName,
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      commentBody,
                      style: TextStyle(color: Color(0x8800325A)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
