import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/helpers/globals.dart';

void main() {
  test('Globals.baseUrl should be https://api.soupmodelmaker.org/', () {
    expect(Globals.baseUrl, 'https://api.soupmodelmaker.org/');
  });
}
