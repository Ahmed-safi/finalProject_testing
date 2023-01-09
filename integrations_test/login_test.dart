import 'package:ECompany/constans_keys/const_keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ECompany/main.dart'as app;
import 'package:integration_test/integration_test.dart';


void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("group_login", () async {
    testWidgets("LoginForm", (tester) async{
      app.main();
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(ConstKey.LEmail), "ahmed20@test.com");
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(ConstKey.LPasword), "a123123a");
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.press(find.byKey(ConstKey.LoginBtn));
      await tester.pumpAndSettle();
    });
  });
}