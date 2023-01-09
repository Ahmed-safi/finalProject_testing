import 'package:flutter/material.dart';
import 'package:ECompany/Screens/ForgetPass/components/forget_screen_top_image.dart';
import 'package:ECompany/responsive.dart';

import '../../components/background.dart';
import 'components/forget_form.dart';
import 'components/forget_screen_top_image.dart';

class ForgetScreen extends StatelessWidget {
  const ForgetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileForgetScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: ForgetScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 450,
                      child: ForgetPasswor(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileForgetScreen extends StatelessWidget {
  const MobileForgetScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const ForgetScreenTopImage(),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: ForgetPasswor(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
