import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'notifications_screen.dart';

class AvailabilityRequestScreen extends StatefulWidget {
  const AvailabilityRequestScreen({super.key, required this.hotel});
  final Hotel hotel;
  @override
  State<AvailabilityRequestScreen> createState() => _AvailabilityRequestScreenState();
}

class _AvailabilityRequestScreenState extends State<AvailabilityRequestScreen> {
  late String room;
  int guests = 2;

  @override
  void initState() {
    super.initState();
    room = widget.hotel.rooms.isEmpty ? 'Стандарт' : widget.hotel.rooms.first.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Проверить наличие')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(child: ListTile(title: Text(widget.hotel.name, style: const TextStyle(fontWeight: FontWeight.w900)), subtitle: Text(widget.hotel.city))),
          const SizedBox(height: 20),
          const Text('Тип номера', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.hotel.rooms
                .map((item) => item.name)
                .toSet()
                .map((name) => ChoiceChip(
                      label: Text(name),
                      selected: room == name,
                      onSelected: (_) => setState(() => room = name),
                    ))
                .toList(),
          ),
          const SizedBox(height: 22),
          const Text('Количество гостей', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
          Row(children: [
            IconButton.filledTonal(onPressed: guests > 1 ? () => setState(() => guests--) : null, icon: const Icon(Icons.remove)),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: Text('$guests', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900))),
            IconButton.filledTonal(onPressed: () => setState(() => guests++), icon: const Icon(Icons.add)),
          ]),
          const SizedBox(height: 22),
          const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Дата и время не требуются. Запрос будет отправлен сейчас.'))),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RequestSentScreen())),
            icon: const Icon(Icons.send_rounded),
            label: const Text('Отправить запрос'),
          ),
          const SizedBox(height: 10),
          const Text('Оператор проверит наличие и ответит вам в уведомлениях.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}

class RequestSentScreen extends StatelessWidget {
  const RequestSentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const Spacer(),
            const CircleAvatar(radius: 48, child: Icon(Icons.send_rounded, size: 42)),
            const SizedBox(height: 24),
            const Text('Запрос отправлен!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            const Text('Ответ оператора придёт в уведомления.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted, fontSize: 16)),
            const Spacer(),
            FilledButton(onPressed: () => Navigator.popUntil(context, (route) => route.isFirst), child: const Text('Вернуться на главную')),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(showBackButton: true),
                ),
              ),
              child: const Text('Перейти в уведомления'),
            ),
          ]),
        ),
      ),
    );
  }
}
