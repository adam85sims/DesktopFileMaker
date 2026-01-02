# Desktop File Maker

**Desktop File Maker** is a simple and intuitive Flutter application designed for Linux. It streamlines the process of creating `.desktop` files (desktop entries), allowing you to easily integrate your applications into the system menu.

## Features

- **Easy File Selection**: Browse and select your executable and icon files using a graphical interface.
- **Metadata Input**: Easily enter application details such as Name and Comment/Description.
- **Category Management**: Choose from standard XDG categories (e.g., Utility, Development, System) via a dropdown menu.
- **Terminal Option**: detailed control over whether your application requires a terminal to run.
- **Automatic Saving**: Automatically validates inputs and saves the generated `.desktop` file to `~/.local/share/applications`, making it immediately available in your desktop environment.

## Getting Started

### Prerequisites

- Linux operating system.
- [Flutter SDK](https://flutter.dev/docs/get-started/install/linux) installed.

### Installation & Build

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd desktop_file_maker
    ```

2.  **Get dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the application:**
    ```bash
    flutter run -d linux
    ```

4.  **Build release version:**
    ```bash
    flutter build linux
    ```
    The executable will be located in `build/linux/x64/release/bundle/`.

## Usage

1.  Launch the application.
2.  Enter the **Name** of the application as you want it to appear in the menu.
3.  Click **Browse** next to "Executable Path" to select the binary or script you want to run.
4.  (Optional) Click **Browse** next to "Icon Path" to select an icon image.
5.  Enter a **Comment** to describe the application.
6.  Select a **Category** from the dropdown menu.
7.  Check **Run in Terminal** if the application is a command-line tool.
8.  Click **Create Desktop File**.
9.  The file will be created in `~/.local/share/applications`. You may need to logout and login or refresh your shell for it to appear in some desktop environments immediately.

## Built With

- [Flutter](https://flutter.dev/) - Google's UI toolkit for building natively compiled applications.
- [file_picker](https://pub.dev/packages/file_picker) - A package that allows you to use the native file explorer to pick files.
