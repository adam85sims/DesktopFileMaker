class DesktopEntry {
  String name = '';
  String execPath = '';
  String iconPath = '';
  String comments = '';
  String category = 'Utility';
  bool terminal = false;

  String get validFileName {
    // Basic sanitization
    return name.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').toLowerCase();
  }

  String toContentString() {
    String finalExec = execPath;
    if (finalExec.contains(' ')) {
      finalExec = '"$finalExec"';
    }

    return '''[Desktop Entry]
Type=Application
Name=$name
Exec=$finalExec
Icon=$iconPath
Comment=$comments
Categories=$category;
Terminal=$terminal
''';
  }
}
