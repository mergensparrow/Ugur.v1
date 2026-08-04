import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool availability = true;
  bool requestUpdates = true;
  bool newReviews = false;
  bool recommendations = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Настройки уведомлений',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  title: const Text('Наличие номеров'),
                  subtitle: const Text('Ответ гостиницы по вашему запросу'),
                  value: availability,
                  onChanged: (value) => setState(() => availability = value),
                ),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  title: const Text('Статус запросов'),
                  subtitle: const Text('Изменения в проверке наличия'),
                  value: requestUpdates,
                  onChanged: (value) => setState(() => requestUpdates = value),
                ),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  title: const Text('Новые отзывы'),
                  value: newReviews,
                  onChanged: (value) => setState(() => newReviews = value),
                ),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  title: const Text('Рекомендации Ugur'),
                  value: recommendations,
                  onChanged: (value) => setState(() => recommendations = value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
