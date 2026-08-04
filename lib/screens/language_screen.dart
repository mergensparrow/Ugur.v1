import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selected = 'Русский';

  @override
  Widget build(BuildContext context) {
    const languages = ['Русский', 'Türkmençe', 'English'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Язык', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: languages.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, index) {
          final language = languages[index];
          return Card(
            child: RadioListTile<String>(
              value: language,
              groupValue: selected,
              title: Text(
                language,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              onChanged: (value) {
                if (value == null) return;
                setState(() => selected = value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Выбран язык: $value')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
