# Desktop Entry Creator - Design Document

## 1. Overview
The **Desktop Entry Creator** is a simple Flutter application designed for Linux users to easily create `.desktop` files (desktop entries) for their applications. This tool eliminates the need to manually write `.desktop` files, providing a user-friendly interface to generate and save them to `~/.local/share/applications`.

## 2. Requirements

### 2.1 Functional Requirements
- **Application Selection**: User can select an executable file from the file system.
- **Icon Selection**: User can select an image file (png, svg, xpm, etc.) for the application icon.
- **Metadata Input**: 
  - Application Name (Display Name)
  - Comment/Description
  - Terminal requirement (Run in terminal?)
- **Category Selection**: Dropdown menu with standard XDG categories.
- **Output Generation**: 
  - Validates inputs.
  - Generates a valid `.desktop` file content.
  - Saves the file to `~/.local/share/applications/<name>.desktop`.
- **Cancellation**: 
  - "Cancel" button.
  - Confirmation dialog: "Are you sure you want to discard changes?"

### 2.2 UI Requirements
- **Theme**: Simple class/material design. Dark mode support preferred.
- **Layout**: 
  - Vertical form layout.
  - Browse buttons next to file path text fields.
  - "Create Desktop File" and "Cancel" buttons at the bottom.

## 3. UI Design Draft

```
+-------------------------------------------------------+
|  Create New Desktop Entry                             |
|-------------------------------------------------------|
|  Name:         [ Input Field                        ] |
|                                                       |
|  Executable:   [ Path/To/Exec         ] [ Browse... ] |
|                                                       |
|  Icon:         [ Path/To/Icon         ] [ Browse... ] |
|                                                       |
|  Comment:      [ Input Field                        ] |
|                                                       |
|  Categories:   [ Dropdown (e.g. Utility)          V ] |
|                                                       |
|  [ ] Run in Terminal?                                 |
|                                                       |
|-------------------------------------------------------|
|          [ Cancel ]        [ Create Desktop File ]    |
+-------------------------------------------------------+
```

### Confirmation Dialog (Cancel)
- Title: "Discard Changes?"
- Content: "Are you sure you want to cancel? All unsaved data will be lost."
- Actions: [No/Back] [Yes/Exit]

## 4. Technical Architecture

### 4.1 Tech Stack
- **Framework**: Flutter (Linux Desktop)
- **Language**: Dart

### 4.2 Key Packages
- `file_picker`: For selecting the executable and icon files.
- `path`: For file path manipulation.
- `xdg_directories` (optional): To reliably find `~/.local/share/applications`, though hardcoding to `~` or using `Platform.environment['HOME']` is often sufficient for a simple tool.

### 4.3 Data Structure (DesktopEntry)
```dart
class DesktopEntry {
  String name;
  String execPath;
  String iconPath;
  String comment;
  String category;
  bool terminal;
  
  String toContentString() {
    return '''[Desktop Entry]
Type=Application
Name=$name
Exec=$execPath
Icon=$iconPath
Comment=$comment
Categories=$category;
Terminal=$terminal
''';
  }
}
```

## 5. Implementation Steps
1.  **Project Setup**: `flutter create .`
2.  **Dependencies**: Add `file_picker`.
3.  **UI Construction**: Build the form widget.
4.  **Logic Integration**: Wire up file pickers and save button.
5.  **Testing**: Verify file creation and syntax.

## 6. Future Enhancements (Out of Scope)
- Support for `MimeType`.
- Support for `Keywords`.
- Localization.
- Editing existing `.desktop` files.
