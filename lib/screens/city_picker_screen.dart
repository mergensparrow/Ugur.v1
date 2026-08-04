import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../theme/app_theme.dart';

class CityPickerScreen extends StatefulWidget {
  const CityPickerScreen({super.key, required this.initialCity});
  final String initialCity;
  @override
  State<CityPickerScreen> createState() => _CityPickerScreenState();
}

class _CityPickerScreenState extends State<CityPickerScreen> {
  late String selected = widget.initialCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выберите город')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 0, 18, 12),
            child: Align(alignment: Alignment.centerLeft, child: Text('Выберите город, чтобы найти лучшие гостиницы', style: TextStyle(color: AppColors.muted))),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: cityNames.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) => RadioListTile<String>(
                value: cityNames[i],
                groupValue: selected,
                onChanged: (v) => setState(() => selected = v!),
                title: Text(cityNames[i], style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18, 12, 18, 18 + MediaQuery.paddingOf(context).bottom),
            child: FilledButton(onPressed: () => Navigator.pop(context, selected), child: const Text('Найти гостиницы')),
          ),
        ],
      ),
    );
  }
}
