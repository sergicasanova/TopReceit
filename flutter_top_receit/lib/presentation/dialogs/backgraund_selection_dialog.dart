import 'package:flutter/material.dart';
import 'package:flutter_top_receit/presentation/functions/backgraund_sharedPref.dart';

class BackgroundSelectionDialog extends StatefulWidget {
  final Function(String) onBackgroundChanged;

  const BackgroundSelectionDialog(
      {super.key, required this.onBackgroundChanged});

  @override
  _BackgroundSelectionDialogState createState() =>
      _BackgroundSelectionDialogState();
}

class _BackgroundSelectionDialogState extends State<BackgroundSelectionDialog> {
  final List<String> bgImages = [
    'assets/bg1.jpeg',
    'assets/bg2.jpeg',
    'assets/bg3.jpeg',
    'assets/bg5.jpeg',
    'assets/bg6.jpeg',
    'assets/bg7.jpeg',
    'assets/bg8.jpeg',
    'assets/bg9.jpeg',
  ];

  String? selectedBackground;

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
  }

  Future<void> _loadBackgroundImage() async {
    final prefs = PreferencesService();
    final bgImage = await prefs.getBackgroundImage();
    setState(() {
      selectedBackground = bgImage;
    });
  }

  Future<void> _saveBackgroundImage(String bgImage) async {
    final prefs = PreferencesService();
    await prefs.saveBackgroundImage(bgImage);
    widget.onBackgroundChanged(bgImage);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccionar fondo de pantalla'),
      content: SingleChildScrollView(
        child: Column(
          children: bgImages.map((bgImage) {
            return GestureDetector(
              onTap: () async {
                await _saveBackgroundImage(bgImage);
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: selectedBackground == bgImage
                    ? Colors.white
                    : Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(bgImage),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
