import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Конфиденциальность',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Политика конфиденциальности Ugur',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 14),
            Text(
              'Ugur использует данные профиля и запросов только для работы сервиса: отображения аккаунта, связи с пользователем и проверки наличия номеров.',
              style: TextStyle(height: 1.55),
            ),
            SizedBox(height: 18),
            Text(
              'Какие данные могут храниться',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 8),
            Text(
              'Имя, номер телефона, email, избранные гостиницы, настройки и история запросов.',
              style: TextStyle(height: 1.55),
            ),
            SizedBox(height: 18),
            Text(
              'Управление данными',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 8),
            Text(
              'Пользователь может изменить данные в личном профиле или запросить удаление аккаунта. Полная юридическая версия документа будет подключена перед публикацией приложения.',
              style: TextStyle(height: 1.55),
            ),
          ],
        ),
      ),
    );
  }
}
