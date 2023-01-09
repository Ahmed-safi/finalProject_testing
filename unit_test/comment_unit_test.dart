import 'package:flutter_test/flutter_test.dart';
void main() {
  // -- Comment cases
  test('add Comment test', () {
    String result = validator._commentController('');
    expect(result, 'Field can\'t be missing');
  });
  test('Comment length < 7', () {
    String result = validator._commentController('great');
    expect(result, 'Comment cant be less than 7 characteres');
  });
  test('valid Comment test', () {
    String result = validator._commentController('great Work');
    expect(result, 'Comment is Valid');
  });
}