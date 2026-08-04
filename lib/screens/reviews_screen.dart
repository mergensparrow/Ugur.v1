import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key, required this.hotel});
  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Отзывы', style: const TextStyle(fontWeight: FontWeight.w900)),
            Text(hotel.name, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.gold, size: 36),
                  const SizedBox(width: 9),
                  Text('${hotel.rating}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                  const SizedBox(width: 8),
                  Text('${hotel.reviews} отзывов', style: const TextStyle(color: AppColors.muted)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const ReviewCard(
            name: 'Алексей Петров',
            date: '12 мая 2024',
            rating: 5,
            text: 'Отличный отель! Чисто, уютно, прекрасный персонал. Обязательно вернусь снова.',
          ),
          const SizedBox(height: 11),
          const ReviewCard(
            name: 'Мяхри А.',
            date: '8 апреля 2026',
            rating: 4,
            text: 'Красивый интерьер, чисто и спокойно. Персонал быстро помог с вопросами. Номер был подготовлен вовремя.',
          ),
          const SizedBox(height: 11),
          const ReviewCard(
            name: 'Бегенч М.',
            date: '19 марта 2026',
            rating: 5,
            text: 'Удобное расположение и внимательный персонал. Понравилась чистота в номере и спокойная атмосфера.',
          ),
          const SizedBox(height: 11),
          const ReviewCard(
            name: 'Анна К.',
            date: '3 февраля 2026',
            rating: 4,
            text: 'Хороший вариант для короткой поездки. Заселение прошло быстро, сотрудники подробно ответили на вопросы.',
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.name,
    required this.date,
    required this.rating,
    required this.text,
  });

  final String name;
  final String date;
  final int rating;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(backgroundColor: Color(0xFFE9ECF0), child: Icon(Icons.person_rounded)),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
                      Text(date, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                    ],
                  ),
                ),
                const Icon(Icons.star_rounded, color: AppColors.gold),
                Text('$rating.0', style: const TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 13),
            Text(text, style: const TextStyle(height: 1.45)),
          ],
        ),
      ),
    );
  }
}
