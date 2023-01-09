import 'package:flutter_test/flutter_test.dart';

void main() {
  //-- Email cases
  test('enter Email test', () {
    String result = validator._emailTextController('');
    expect(result, 'Please enter a valid Email');
  });
  test('enter Email test', () {
    String result = validator._emailTextController('ahmed20@com');
    expect(result, 'Please enter a valid Email');
  });
  test('valid Email test', () {
    String result = validator._emailTextController('ahmed20@test.com');
    expect(result, 'Email is valid ');
  });
}

