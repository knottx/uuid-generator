import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UUID Generator',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

enum UuidVersion {
  v1,
  v4,
  v7;

  String get uuid {
    switch (this) {
      case UuidVersion.v1:
        return Uuid().v1();
      case UuidVersion.v4:
        return Uuid().v4();
      case UuidVersion.v7:
        return Uuid().v7();
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UuidVersion _selectedVersion = UuidVersion.v4;
  String _uuid = '';

  @override
  void initState() {
    super.initState();
    generateUuid();
  }

  void generateUuid() {
    setState(() {
      _uuid = _selectedVersion.uuid;
    });
  }

  void copyToClipboard() {
    if (_uuid.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _uuid));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            Text('Copied!'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _title(),
              _versionSelection(),
              _displayUuid(),
              _generateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Text(
      'UUID Generator',
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _versionSelection() {
    return Wrap(
      spacing: 8,
      alignment: WrapAlignment.center,
      children:
          UuidVersion.values.map((version) {
            return ChoiceChip(
              label: Text(version.name.toUpperCase()),
              selected: _selectedVersion == version,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    if (_selectedVersion != version) {
                      _uuid = version.uuid;
                    }
                    _selectedVersion = version;
                  });
                }
              },
            );
          }).toList(),
    );
  }

  Widget _displayUuid() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          SelectableText(
            _uuid,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            textAlign: TextAlign.center,
          ),
          IconButton(onPressed: copyToClipboard, icon: Icon(Icons.copy)),
        ],
      ),
    );
  }

  Widget _generateButton() {
    return Center(
      child: FilledButton(
        onPressed: generateUuid,
        style: FilledButton.styleFrom(minimumSize: Size(240, 48)),
        child: Text('Generate UUID'),
      ),
    );
  }
}
