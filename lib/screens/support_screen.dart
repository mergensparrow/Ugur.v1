import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Поддержка',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.support_agent_rounded, size: 42),
                  SizedBox(height: 12),
                  Text(
                    'Чем можем помочь?',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Опишите вопрос, связанный с гостиницей, запросом наличия или работой приложения.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => _showMessage(
              context,
              'Форма обращения открыта. Серверная отправка будет подключена позже.',
            ),
            icon: const Icon(Icons.chat_outlined),
            label: const Text('Написать в поддержку'),
          ),
          const SizedBox(height: 18),
          const Text(
            'Частые вопросы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          const Card(
            child: ExpansionTile(
              title: Text('Как работает проверка наличия?'),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    'Запрос передаётся оператору Ugur, который уточняет актуальное наличие у гостиницы.',
                  ),
                ),
              ],
            ),
          ),
          const Card(
            child: ExpansionTile(
              title: Text('Можно ли забронировать онлайн?'),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    'Онлайн-бронирование пока не подключено. Сейчас приложение предоставляет информацию и проверку наличия.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
