import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_file_maker/desktop_entry.dart';

void main() {
  test('DesktopEntry validFileName sanitization', () {
    final entry = DesktopEntry()..name = 'My Cool App!';
    expect(entry.validFileName, 'my_cool_app_');
  });

  test('DesktopEntry content generation', () {
    final entry = DesktopEntry()
      ..name = 'Test App'
      ..execPath = '/usr/bin/test'
      ..iconPath = '/usr/share/icons/test.png'
      ..comments = 'A test application'
      ..category = 'Utility'
      ..terminal = true;

    final expected = '''[Desktop Entry]
Type=Application
Name=Test App
Exec=/usr/bin/test
Icon=/usr/share/icons/test.png
Comment=A test application
Categories=Utility;
Terminal=true
''';

    expect(entry.toContentString(), expected);
  });

  test('DesktopEntry quotes Exec path with spaces', () {
    final entry = DesktopEntry()
      ..name = 'Space App'
      ..execPath = '/usr/bin/test space'
      ..iconPath = '/usr/share/icons/test.png';

    expect(entry.toContentString(), contains('Exec="/usr/bin/test space"'));
  });
}
