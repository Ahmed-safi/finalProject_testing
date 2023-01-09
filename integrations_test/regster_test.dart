import 'package:ECompany/constans_keys/const_keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test_driver.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ECompany/main.dart'as app;

void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("group_auth", () async {
    testWidgets("SignUpForm", (tester) async{
      app.main();
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(ConstKey.FName), "Ahmed");
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(ConstKey.Email), "ahmed20@test.com");
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(ConstKey.Pasword), "a123123a");
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(ConstKey.PhonN), "0590000000");
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(ConstKey.Position), "Programer");
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.press(find.byKey(ConstKey.SinupBtn));
      await tester.pumpAndSettle();

    });
  });
}
