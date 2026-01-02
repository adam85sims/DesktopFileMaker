import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'desktop_entry.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _entry = DesktopEntry();

  final _execController = TextEditingController();
  final _iconController = TextEditingController();

  final List<String> _categories = [
    'AudioVideo',
    'Development',
    'Education',
    'Game',
    'Graphics',
    'Network',
    'Office',
    'Settings',
    'System',
    'Utility',
  ];

  @override
  void dispose() {
    _execController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  Future<void> _pickExecutable() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _execController.text = result.files.single.path!;
        _entry.execPath = result.files.single.path!;
      });
    }
  }

  Future<void> _pickIcon() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _iconController.text = result.files.single.path!;
        _entry.iconPath = result.files.single.path!;
      });
    }
  }

  void _createDesktopFile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // If it's a shell script, make sure it's executable
        if (_entry.execPath.endsWith('.sh')) {
          await Process.run('chmod', ['+x', _entry.execPath]);
        }

        final home = Platform.environment['HOME'];
        if (home == null) {
          throw Exception('Could not access HOME directory');
        }

        // Ensure directory exists
        final appDir = Directory('$home/.local/share/applications');
        if (!await appDir.exists()) {
          await appDir.create(recursive: true);
        }

        final filePath = '${appDir.path}/${_entry.validFileName}.desktop';
        final file = File(filePath);
        await file.writeAsString(_entry.toContentString());

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Created $filePath')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Discard Changes?'),
            content: const Text(
              'Are you sure you want to cancel? All unsaved data will be lost.',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Desktop Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => _entry.name = value!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _execController,
                      decoration: const InputDecoration(
                        labelText: 'Executable',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an executable';
                        }
                        return null;
                      },
                      onSaved: (value) => _entry.execPath = value!,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _pickExecutable,
                    child: const Text('Browse...'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _iconController,
                      decoration: const InputDecoration(
                        labelText: 'Icon',
                        border: OutlineInputBorder(),
                      ),
                      // Icon is optional usually, but good to have
                      onSaved: (value) => _entry.iconPath = value ?? '',
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _pickIcon,
                    child: const Text('Browse...'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _entry.comments = value ?? '',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _entry.category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _entry.category = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Run in Terminal?'),
                value: _entry.terminal,
                onChanged: (bool? value) {
                  setState(() {
                    _entry.terminal = value!;
                  });
                },
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      if (await _onWillPop()) {
                        exit(0); // Or clear form
                      }
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: _createDesktopFile,
                    child: const Text('Create Desktop File'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
