import 'package:flutter/material.dart';
import '../data/favorites_store.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'availability_request_screen.dart';
import 'reviews_screen.dart';
import 'room_prices_screen.dart';

class HotelDetailScreen extends StatefulWidget {
  const HotelDetailScreen({super.key, required this.hotel});
  final Hotel hotel;

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  static const tabLabels = ['Об отеле', 'Удобства'];
  int selectedTab = 0;

  Hotel get hotel => widget.hotel;

  void _share() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ссылка на ${hotel.name} подготовлена.')),
    );
  }

  void _openReviews() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReviewsScreen(hotel: hotel)));
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = 34 + MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: 330,
            backgroundColor: Colors.white,
            foregroundColor: AppColors.text,
            title: Text(hotel.name, style: const TextStyle(fontWeight: FontWeight.w900)),
            actions: [
              IconButton.filledTonal(tooltip: 'Поделиться', onPressed: _share, icon: const Icon(Icons.share_outlined)),
              ValueListenableBuilder<Set<String>>(
                valueListenable: FavoritesStore.hotels,
                builder: (_, favorites, __) {
                  final favorite = favorites.contains(hotel.name);
                  return IconButton.filledTonal(
                    tooltip: 'Избранное',
                    onPressed: () => FavoritesStore.toggle(hotel.name),
                    icon: Icon(favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: favorite ? AppColors.danger : null),
                  );
                },
              ),
              const SizedBox(width: 7),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(hotel.image, fit: BoxFit.cover, filterQuality: FilterQuality.high),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x25000000), Colors.transparent, Color(0x66000000)]),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    bottom: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xB5000000), borderRadius: BorderRadius.circular(12)),
                      child: const Text('1 / 24', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18, 19, 18, bottomPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(hotel.name, style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w900, letterSpacing: -.8)),
                            const SizedBox(height: 4),
                            Text(hotel.city, style: const TextStyle(color: AppColors.muted, fontSize: 14)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(children: [const Icon(Icons.star_rounded, color: AppColors.gold, size: 23), Text(' ${hotel.rating}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))]),
                          Text('${hotel.reviews} отзывов', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  _AvailabilityLine(status: hotel.status),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.muted, size: 19),
                      const SizedBox(width: 7),
                      Expanded(child: Text(hotel.address, style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.35))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _AmenitiesStrip(amenities: hotel.amenities, compact: true),
                  const SizedBox(height: 18),
                  Text('от ${hotel.price} TMT / ночь', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  const Text('Цена за стандартный номер', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                  const SizedBox(height: 16),
                  _ActionButton(
                    background: AppColors.gold,
                    foreground: AppColors.text,
                    icon: Icons.payments_outlined,
                    label: 'Цены на номера',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RoomPricesScreen(hotel: hotel))),
                  ),
                  const SizedBox(height: 9),
                  _ActionButton(
                    background: AppColors.navy,
                    foreground: Colors.white,
                    icon: Icons.search_rounded,
                    label: 'Проверить наличие',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AvailabilityRequestScreen(hotel: hotel))),
                  ),
                  const SizedBox(height: 9),
                  const _ActionButton(
                    background: Color(0xFF101315),
                    foreground: Colors.white70,
                    icon: Icons.lock_outline,
                    label: 'Онлайн-бронирование · Скоро в Ugur',
                  ),
                  const SizedBox(height: 21),
                  Row(
                    children: List.generate(tabLabels.length, (index) {
                      final selected = selectedTab == index;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: index == 0 ? 8 : 0),
                          child: OutlinedButton(
                            onPressed: () => setState(() => selectedTab = index),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: selected ? AppColors.navy : Colors.white,
                              foregroundColor: selected ? Colors.white : AppColors.text,
                              minimumSize: const Size.fromHeight(48),
                              side: BorderSide(color: selected ? AppColors.navy : const Color(0x18000000)),
                            ),
                            child: Text(tabLabels[index]),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  if (selectedTab == 0)
                    _AboutContent(hotel: hotel, onShowReviews: _openReviews)
                  else
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                        child: _AmenitiesStrip(amenities: hotel.amenities),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.background, required this.foreground, required this.icon, required this.label, this.onTap});
  final Color background;
  final Color foreground;
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: SizedBox(
          height: 57,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foreground, size: 21),
              const SizedBox(width: 9),
              Flexible(child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: foreground, fontWeight: FontWeight.w900, fontSize: 15))),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent({required this.hotel, required this.onShowReviews});
  final Hotel hotel;
  final VoidCallback onShowReviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Описание отеля', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                Text(
                  '${hotel.name} — гостиничный комплекс в городе ${hotel.city}. ${hotel.description} Комфортные номера, сервис и удобное расположение подходят как для отдыха, так и для деловых поездок.',
                  style: const TextStyle(fontSize: 14, height: 1.55),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Удобства', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
            child: _AmenitiesStrip(amenities: hotel.amenities),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(child: Text('Отзывы гостей', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
            TextButton(onPressed: onShowReviews, child: const Text('Все отзывы ›')),
          ],
        ),
        const SizedBox(height: 8),
        const _ReviewPreview(),
      ],
    );
  }
}

class _ReviewPreview extends StatelessWidget {
  const _ReviewPreview();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(backgroundColor: Color(0xFFE9ECF0), child: Icon(Icons.person_rounded)),
                SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Алексей Петров', style: TextStyle(fontWeight: FontWeight.w900)),
                      Text('12 мая 2024', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                    ],
                  ),
                ),
                Icon(Icons.star_rounded, color: AppColors.gold),
                Text('5.0', style: TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Отличный отель! Чисто, уютно, прекрасный персонал. Обязательно вернусь снова.', style: TextStyle(height: 1.45)),
          ],
        ),
      ),
    );
  }
}

class _AmenitiesStrip extends StatelessWidget {
  const _AmenitiesStrip({required this.amenities, this.compact = false});
  final List<String> amenities;
  final bool compact;

  static const iconByAmenity = <String, IconData>{
    'Wi‑Fi': Icons.wifi_rounded,
    'Парковка': Icons.local_parking_outlined,
    'Бассейн': Icons.pool_outlined,
    'Ресторан': Icons.restaurant_outlined,
    'Кондиционер': Icons.ac_unit_rounded,
    'Завтрак': Icons.free_breakfast_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 70 : 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: amenities.length,
        separatorBuilder: (_, __) => SizedBox(width: compact ? 17 : 20),
        itemBuilder: (_, index) {
          final label = amenities[index];
          final icon = iconByAmenity[label] ?? Icons.check_circle_outline_rounded;
          return SizedBox(
            width: compact ? 58 : 68,
            child: Column(
              children: [
                Container(
                  width: compact ? 42 : 47,
                  height: compact ? 42 : 47,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0x10000000), blurRadius: 11)]),
                  child: Icon(icon, size: compact ? 21 : 23),
                ),
                const SizedBox(height: 6),
                Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: compact ? 9 : 10)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AvailabilityLine extends StatelessWidget {
  const _AvailabilityLine({required this.status});
  final AvailabilityStatus status;

  Color get color => switch (status) {
        AvailabilityStatus.available => AppColors.success,
        AvailabilityStatus.unavailable => AppColors.danger,
        AvailabilityStatus.recheck => AppColors.warning,
        AvailabilityStatus.checking => AppColors.gold,
      };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 8),
        Text(status.label, style: TextStyle(color: color, fontWeight: FontWeight.w900)),
      ],
    );
  }
}
