import 'package:flutter_test/flutter_test.dart';

void main() {
  //--Category cases
  test('Select Category test', () {
    String result = validator._categoryController ('');
    expect(result, 'Field can\'t be missing');
  });
  test('Valid Category test', () {
    String result = validator._categoryController ('Programer');
    expect(result, 'Category is Valid');
  });
  //--Title cases
  test('enter Title test', () {
    String result = validator._titleController ('');
    expect(result, 'Field can\'t be missing');
  });
  test('Valid Title test', () {
    String result = validator._titleController ('app flutter');
    expect(result, 'Title is Valid');
  });
  //--Description cases
  test('enter Description test', () {
    String result = validator._descriptionController ('');
    expect(result, 'Field can\'t be missing');
  });
  test('Valid Description test', () {
    String result = validator._descriptionController ('Tow page ui app flutter');
    expect(result, 'Description is Valid');
  });
  //--Deadline cases
  test('enter Deadline test', () {
    String result = validator._deadlineDateController ('');
    expect(result, 'Field can\'t be missing');
  });
  test('Valid Deadline test', () {
    String result = validator._deadlineDateController ('10-1-2023');
    expect(result, 'Deadline is Valid');
  });

}