import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../data/favorites_store.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/mockup_image_slice.dart';
import 'hotel_detail_screen.dart';

Widget _approvedFavoritePhoto(Hotel hotel) {
  final rect = switch (hotel.name) {
    'Avaza Grand Hotel' => const Rect.fromLTWH(55, 620, 244, 246),
    'Mary Hotel' => const Rect.fromLTWH(55, 925, 244, 248),
    'Dashoguz Hotel' => const Rect.fromLTWH(55, 1233, 244, 247),
    _ => null,
  };
  if (rect == null) return Image.asset(hotel.image, fit: BoxFit.cover);
  return MockupImageSlice(
    asset: 'assets/images/mockup_favorites.jpeg',
    sourceSize: const Size(853, 1844),
    sourceRect: rect,
  );
}

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int selectedTab = 0;

  List<Hotel> _filtered(List<Hotel> source) {
    return switch (selectedTab) {
      1 => source.where((hotel) => hotel.status == AvailabilityStatus.available).toList(),
      2 => source
          .where((hotel) =>
              hotel.status == AvailabilityStatus.recheck ||
              hotel.status == AvailabilityStatus.checking)
          .toList(),
      _ => source,
    };
  }

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return SafeArea(
      child: ValueListenableBuilder<Set<String>>(
        valueListenable: FavoritesStore.hotels,
        builder: (_, favorites, __) {
          final favoriteHotels = hotels.where((hotel) => favorites.contains(hotel.name)).toList();
          final visible = _filtered(favoriteHotels);
          final availableCount = favoriteHotels.where((hotel) => hotel.status == AvailabilityStatus.available).length;
          final clarifyCount = favoriteHotels
              .where((hotel) =>
                  hotel.status == AvailabilityStatus.recheck ||
                  hotel.status == AvailabilityStatus.checking)
              .length;

          return ListView(
            padding: EdgeInsets.fromLTRB(compact ? 10 : 16, compact ? 8 : 14, compact ? 10 : 16, 22),
            children: [
              _FavoritesHeader(count: favoriteHotels.length),
              SizedBox(height: compact ? 14 : 22),
              _SegmentTabs(
                selectedIndex: selectedTab,
                labels: [
                  'Все ${favoriteHotels.length}',
                  'С номерами $availableCount',
                  'Нужно уточнить $clarifyCount',
                ],
                onSelected: (value) => setState(() => selectedTab = value),
              ),
              SizedBox(height: compact ? 13 : 24),
              if (visible.isEmpty)
                const _EmptyFavorites()
              else
                ...visible.map(
                  (hotel) => Padding(
                    padding: EdgeInsets.only(bottom: compact ? 10 : 14),
                    child: _FavoriteHotelCard(
                      hotel: hotel,
                      onOpen: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => HotelDetailScreen(hotel: hotel)),
                      ),
                      onFavorite: () => FavoritesStore.toggle(hotel.name),
                    ),
                  ),
                ),
              if (favoriteHotels.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 11 : 16,
                    vertical: compact ? 6 : 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.navy,
                        size: compact ? 18 : 23,
                      ),
                      SizedBox(width: compact ? 7 : 10),
                      Expanded(
                        child: Text(
                          'Статус обновляется после ответа оператора',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: compact ? 10.4 : 12.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _FavoritesHeader extends StatelessWidget {
  const _FavoritesHeader({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return SizedBox(
      height: compact ? 142 : 194,
      child: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: _FavoritesHeaderPainter())),
          Positioned(
            left: compact ? 9 : 4,
            top: compact ? 50 : 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Избранное',
                  style: TextStyle(
                    fontSize: compact ? 30 : 44,
                    height: 1,
                    letterSpacing: -1.2,
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: compact ? 6 : 12),
                Text(
                  '$count сохранённые гостиницы',
                  style: TextStyle(fontSize: compact ? 13.2 : 18, color: AppColors.muted),
                ),
              ],
          ),
          ),
        ],
      ),
    );
  }
}

class _FavoritesHeaderPainter extends CustomPainter {
  const _FavoritesHeaderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final faint = Paint()
      ..color = const Color(0x217FA1C7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8;
    final baseY = size.height * .86;
    for (var i = 0; i < 12; i++) {
      final x = size.width * (.53 + i * .045);
      final h = 12.0 + (i % 4) * 9;
      canvas.drawRect(Rect.fromLTWH(x, baseY - h, 12, h), faint);
      canvas.drawLine(Offset(x + 6, baseY - h), Offset(x + 6, baseY - h - 10), faint);
    }

    final gold = Paint()
      ..color = const Color(0xFFCB982B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.35;
    final heartCenterX = size.width * .80;
    final heartTop = size.height * .14;
    final heartWidth = size.width * .23;
    final heartHeight = size.height * .48;
    final heart = Path()
      ..moveTo(heartCenterX, heartTop + heartHeight)
      ..cubicTo(
        heartCenterX - heartWidth * .16,
        heartTop + heartHeight * .88,
        heartCenterX - heartWidth * .50,
        heartTop + heartHeight * .68,
        heartCenterX - heartWidth * .50,
        heartTop + heartHeight * .38,
      )
      ..cubicTo(
        heartCenterX - heartWidth * .50,
        heartTop + heartHeight * .08,
        heartCenterX - heartWidth * .16,
        heartTop,
        heartCenterX,
        heartTop + heartHeight * .26,
      )
      ..cubicTo(
        heartCenterX + heartWidth * .16,
        heartTop,
        heartCenterX + heartWidth * .50,
        heartTop + heartHeight * .08,
        heartCenterX + heartWidth * .50,
        heartTop + heartHeight * .38,
      )
      ..cubicTo(
        heartCenterX + heartWidth * .50,
        heartTop + heartHeight * .68,
        heartCenterX + heartWidth * .16,
        heartTop + heartHeight * .88,
        heartCenterX,
        heartTop + heartHeight,
      );
    canvas.drawPath(heart, gold);

    final route = Path()
      ..moveTo(size.width * .42, baseY)
      ..cubicTo(size.width * .56, baseY - 2, size.width * .54, size.height * .62, size.width * .68, size.height * .57);
    canvas.drawPath(route, gold);
    final dot = Paint()..color = const Color(0xFFCB982B);
    final white = Paint()..color = Colors.white;
    for (final p in [
      Offset(size.width * .54, size.height * .74),
      Offset(size.width * .67, size.height * .58),
    ]) {
      canvas.drawCircle(p, 5.5, dot);
      canvas.drawCircle(p, 2.0, white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SegmentTabs extends StatelessWidget {
  const _SegmentTabs({
    required this.selectedIndex,
    required this.labels,
    required this.onSelected,
  });

  final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return Container(
      height: compact ? 40 : 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = index == selectedIndex;
          return Expanded(
            child: InkWell(
              onTap: () => onSelected(index),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 210),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.navy : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: compact ? 4 : 8),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      labels[index],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.navy,
                        fontSize: compact ? 10.1 : 13.5,
                        fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _FavoriteHotelCard extends StatelessWidget {
  const _FavoriteHotelCard({
    required this.hotel,
    required this.onOpen,
    required this.onFavorite,
  });

  final Hotel hotel;
  final VoidCallback onOpen;
  final VoidCallback onFavorite;

  Color get statusColor => switch (hotel.status) {
        AvailabilityStatus.available => AppColors.success,
        AvailabilityStatus.unavailable => AppColors.danger,
        AvailabilityStatus.recheck || AvailabilityStatus.checking => AppColors.warning,
      };

  IconData get statusIcon => switch (hotel.status) {
        AvailabilityStatus.available => Icons.check_circle_outline_rounded,
        AvailabilityStatus.unavailable => Icons.remove_circle_outline_rounded,
        AvailabilityStatus.recheck || AvailabilityStatus.checking => Icons.schedule_rounded,
      };

  String get statusText => switch (hotel.status) {
        AvailabilityStatus.available => 'Номера есть',
        AvailabilityStatus.unavailable => 'Свободных номеров нет',
        AvailabilityStatus.recheck || AvailabilityStatus.checking => 'Наличие не подтверждено',
      };

  String get checkedText => switch (hotel.status) {
        AvailabilityStatus.available || AvailabilityStatus.unavailable => 'Проверено сегодня, 09:00',
        AvailabilityStatus.recheck || AvailabilityStatus.checking => 'Последняя проверка вчера, 18:40',
      };

  @override
  Widget build(BuildContext context) {
    final showOperator =
        hotel.status == AvailabilityStatus.recheck ||
        hotel.status == AvailabilityStatus.checking;
    final compact = context.isCompactLayout;

    return SizedBox(
      height: compact ? 146 : 186,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: EdgeInsets.all(compact ? 8 : 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10031B4E),
                  blurRadius: 18,
                  offset: Offset(0, 7),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(compact ? 14 : 18),
                  child: SizedBox(
                    width: compact ? 90 : 116,
                    height: compact ? 90 : 132,
                    child: _approvedFavoritePhoto(hotel),
                  ),
                ),
                SizedBox(width: compact ? 10 : 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              hotel.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'serif',
                                fontSize: compact ? 15.2 : 21,
                                height: 1.03,
                                color: AppColors.navy,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: onFavorite,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: compact ? 29 : 36,
                              minHeight: compact ? 29 : 36,
                            ),
                            icon: Icon(
                              Icons.favorite_rounded,
                              color: AppColors.danger,
                              size: compact ? 21 : 29,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${hotel.city}  ·  от ${hotel.price} TMT',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: compact ? 10.6 : 14,
                        ),
                      ),
                      SizedBox(height: compact ? 6 : 12),
                      Row(
                        children: [
                          Icon(
                            statusIcon,
                            color: statusColor,
                            size: compact ? 18 : 22,
                          ),
                          SizedBox(width: compact ? 5 : 8),
                          Expanded(
                            child: Text(
                              statusText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: compact ? 10.8 : 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 4 : 9),
                      Text(
                        checkedText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: compact ? 9.6 : 12.5,
                        ),
                      ),
                      SizedBox(height: compact ? 3 : 8),
                      SizedBox(
                        height: compact ? 25 : 34,
                        width: double.infinity,
                        child: showOperator
                            ? OutlinedButton.icon(
                                onPressed: onOpen,
                                icon: Icon(
                                  Icons.support_agent_rounded,
                                  size: compact ? 15 : 18,
                                ),
                                label: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Уточнить у оператора',
                                    style: TextStyle(fontSize: compact ? 9.8 : 13),
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size.fromHeight(compact ? 25 : 34),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: compact ? 4 : 10,
                                  ),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: compact ? 42 : 53),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.navy,
                    size: compact ? 21 : 27,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 76, bottom: 120),
      child: Column(
        children: [
          Icon(Icons.favorite_border_rounded, size: 62, color: AppColors.muted),
          SizedBox(height: 16),
          Text('Пока нет избранных гостиниц', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
