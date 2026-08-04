import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../data/demo_data.dart';
import '../data/favorites_store.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'hotel_detail_screen.dart';
import 'notifications_screen.dart';

class HotelCatalogScreen extends StatefulWidget {
  const HotelCatalogScreen({super.key, required this.city});
  final String city;

  @override
  State<HotelCatalogScreen> createState() => _HotelCatalogScreenState();
}

class _HotelCatalogScreenState extends State<HotelCatalogScreen> {
  String? activeSort;
  RangeValues priceRange = const RangeValues(0, 3000);
  double minRating = 0;
  bool onlyAvailable = false;
  Set<String> selectedAmenities = <String>{};

  static const allAmenities = ['Wi‑Fi', 'Парковка', 'Бассейн', 'Ресторан', 'Кондиционер', 'Завтрак'];

  bool get filtersApplied => priceRange.start > 0 || priceRange.end < 3000 || minRating > 0 || onlyAvailable || selectedAmenities.isNotEmpty;

  List<Hotel> get cityHotels {
    final result = hotelsForCity(widget.city).where((hotel) {
      return hotel.price >= priceRange.start &&
          hotel.price <= priceRange.end &&
          hotel.rating >= minRating &&
          (!onlyAvailable || hotel.status == AvailabilityStatus.available) &&
          selectedAmenities.every(hotel.amenities.contains);
    }).toList();
    if (activeSort == 'Цена') result.sort((a, b) => a.price.compareTo(b.price));
    if (activeSort == 'Рейтинг') result.sort((a, b) => b.rating.compareTo(a.rating));
    if (activeSort == 'Наличие') {
      result.sort((a, b) => _availabilityOrder(a.status).compareTo(_availabilityOrder(b.status)));
    }
    return result;
  }

  int _availabilityOrder(AvailabilityStatus status) => switch (status) {
        AvailabilityStatus.available => 0,
        AvailabilityStatus.checking => 1,
        AvailabilityStatus.recheck => 2,
        AvailabilityStatus.unavailable => 3,
      };

  void _toggleSort(String value) => setState(() => activeSort = activeSort == value ? null : value);

  void _openHotel(Hotel hotel) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => HotelDetailScreen(hotel: hotel)));
  }

  void _openNotifications() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen(showBackButton: true)));
  }

  void _showReviews(Hotel hotel) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 42),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 610),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 7),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Закрыть',
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: const Icon(Icons.close_rounded),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Отзывы — ${hotel.name}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                          Text('${hotel.reviews} отзывов · рейтинг ${hotel.rating}', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              const Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    children: [
                      _CatalogReviewCard(name: 'Алексей Петров', date: '12 мая 2024', rating: 5, text: 'Отличный отель! Чисто, уютно и хороший персонал. Обязательно вернусь снова.'),
                      SizedBox(height: 10),
                      _CatalogReviewCard(name: 'Мяхри А.', date: '8 апреля 2026', rating: 4, text: 'Красивый интерьер, чисто и спокойно. Персонал быстро помог с вопросами.'),
                      SizedBox(height: 10),
                      _CatalogReviewCard(name: 'Бегенч М.', date: '19 марта 2026', rating: 5, text: 'Удобное расположение и внимательный персонал. Номер был подготовлен вовремя.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openFilters() async {
    var draftPrice = priceRange;
    var draftRating = minRating;
    var draftOnlyAvailable = onlyAvailable;
    var draftAmenities = Set<String>.from(selectedAmenities);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Фильтры гостиниц', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Expanded(child: Text('Цена за ночь', style: TextStyle(fontWeight: FontWeight.w900))),
                    Text('${draftPrice.start.round()}–${draftPrice.end.round()} TMT', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900)),
                  ],
                ),
                RangeSlider(
                  min: 0,
                  max: 3000,
                  divisions: 30,
                  values: draftPrice,
                  labels: RangeLabels('${draftPrice.start.round()} TMT', '${draftPrice.end.round()} TMT'),
                  onChanged: (value) => setSheetState(() => draftPrice = value),
                ),
                const SizedBox(height: 10),
                const Text('Минимальный рейтинг', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 8,
                  children: [0.0, 3.0, 4.0, 4.5].map((rating) => ChoiceChip(
                    selected: draftRating == rating,
                    label: Text(rating == 0 ? 'Любой' : '$rating+'),
                    onSelected: (_) => setSheetState(() => draftRating = rating),
                  )).toList(),
                ),
                const SizedBox(height: 13),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  value: draftOnlyAvailable,
                  title: const Text('Только с доступными номерами', style: TextStyle(fontWeight: FontWeight.w900)),
                  onChanged: (value) => setSheetState(() => draftOnlyAvailable = value),
                ),
                const Text('Удобства', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: allAmenities.map((amenity) => FilterChip(
                    selected: draftAmenities.contains(amenity),
                    label: Text(amenity),
                    onSelected: (value) {
                      setSheetState(() {
                        if (value) {
                          draftAmenities.add(amenity);
                        } else {
                          draftAmenities.remove(amenity);
                        }
                      });
                    },
                  )).toList(),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setSheetState(() {
                          draftPrice = const RangeValues(0, 3000);
                          draftRating = 0;
                          draftOnlyAvailable = false;
                          draftAmenities = <String>{};
                        }),
                        child: const Text('Сбросить'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            priceRange = draftPrice;
                            minRating = draftRating;
                            onlyAvailable = draftOnlyAvailable;
                            selectedAmenities = draftAmenities;
                          });
                          Navigator.pop(sheetContext);
                        },
                        child: const Text('Применить'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = cityHotels;
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (_, __) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          toolbarHeight: 74,
          titleSpacing: 18,
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.city, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -.7)),
              Text('${list.length} гостиниц найдено', style: const TextStyle(fontSize: 13, color: AppColors.muted)),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: AppState.instance.unreadNotifications > 0
                  ? Badge(
                      label: Text('${AppState.instance.unreadNotifications}'),
                      child: IconButton(onPressed: _openNotifications, icon: const Icon(Icons.notifications_none_rounded, size: 29)),
                    )
                  : IconButton(onPressed: _openNotifications, icon: const Icon(Icons.notifications_none_rounded, size: 29)),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 7, 12, 8),
              child: Row(
                children: [
                  Expanded(child: _FilterPill(icon: Icons.savings_outlined, label: 'Цена', selected: activeSort == 'Цена', onTap: () => _toggleSort('Цена'))),
                  const SizedBox(width: 6),
                  Expanded(child: _FilterPill(icon: Icons.star_rounded, label: 'Рейтинг', selected: activeSort == 'Рейтинг', onTap: () => _toggleSort('Рейтинг'))),
                  const SizedBox(width: 6),
                  Expanded(child: _FilterPill(icon: Icons.bed_outlined, label: 'Наличие', selected: activeSort == 'Наличие', onTap: () => _toggleSort('Наличие'))),
                  const SizedBox(width: 6),
                  Expanded(child: _FilterPill(icon: Icons.tune_rounded, label: 'Фильтры', selected: filtersApplied, onTap: _openFilters)),
                ],
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? _EmptyCatalog(city: widget.city, filtersApplied: filtersApplied, onReset: () => setState(() {
                      priceRange = const RangeValues(0, 3000);
                      minRating = 0;
                      onlyAvailable = false;
                      selectedAmenities = <String>{};
                    }))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(15, 7, 15, 26),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final hotel = list[index];
                        final favorite = AppState.instance.isFavorite(hotel.name);
                        return index == 0
                            ? _FeaturedHotelCard(
                                hotel: hotel,
                                isFavorite: favorite,
                                onFavorite: () => FavoritesStore.toggle(hotel.name),
                                onTap: () => _openHotel(hotel),
                                onReviews: () => _showReviews(hotel),
                              )
                            : _CompactHotelCard(
                                hotel: hotel,
                                isFavorite: favorite,
                                onFavorite: () => FavoritesStore.toggle(hotel.name),
                                onTap: () => _openHotel(hotel),
                                onReviews: () => _showReviews(hotel),
                              );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog({required this.city, required this.filtersApplied, required this.onReset});
  final String city;
  final bool filtersApplied;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hotel_outlined, size: 60, color: AppColors.muted),
            const SizedBox(height: 15),
            Text(filtersApplied ? 'По выбранным фильтрам ничего не найдено' : 'В городе $city пока нет добавленных гостиниц', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            if (filtersApplied) ...[
              const SizedBox(height: 16),
              OutlinedButton(onPressed: onReset, child: const Text('Сбросить фильтры')),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFFFF4D7) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 46,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  Icon(icon, color: selected ? AppColors.gold : AppColors.text, size: 17),
                  const SizedBox(width: 4),
                  Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedHotelCard extends StatelessWidget {
  const _FeaturedHotelCard({required this.hotel, required this.isFavorite, required this.onFavorite, required this.onTap, required this.onReviews});
  final Hotel hotel;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;
  final VoidCallback onReviews;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(hotel.image, width: double.infinity, height: 165, fit: BoxFit.cover, filterQuality: FilterQuality.high),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 10, 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(hotel.name, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900))),
                      _StatusBadge(status: hotel.status),
                    ],
                  ),
                  Text(hotel.city, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.gold, size: 20),
                      Text(' ${hotel.rating} (${hotel.reviews} отзывов)', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                      const Spacer(),
                      Text('от ${hotel.price} TMT / ночь', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  SizedBox(
                    height: 44,
                    child: Row(
                      children: [
                        const Icon(Icons.star_border_rounded, size: 19),
                        Text(' ${hotel.rating}', style: const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: onReviews,
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                            child: Row(children: [const Icon(Icons.chat_bubble_outline_rounded, size: 18), Text(' ${hotel.reviews}', style: const TextStyle(fontWeight: FontWeight.w700))]),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: 'Избранное',
                          onPressed: onFavorite,
                          icon: Icon(isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: isFavorite ? AppColors.danger : AppColors.text),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactHotelCard extends StatelessWidget {
  const _CompactHotelCard({required this.hotel, required this.isFavorite, required this.onFavorite, required this.onTap, required this.onReviews});
  final Hotel hotel;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;
  final VoidCallback onReviews;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 188,
          child: Row(
            children: [
              SizedBox(width: 135, height: double.infinity, child: Image.asset(hotel.image, fit: BoxFit.cover, filterQuality: FilterQuality.high)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 7, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(hotel.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18, height: 1.05, fontWeight: FontWeight.w900)),
                      if (hotel.status != AvailabilityStatus.available) ...[
                        const SizedBox(height: 4),
                        _StatusBadge(status: hotel.status),
                      ],
                      const SizedBox(height: 5),
                      Text(hotel.city, style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.gold, size: 18),
                          Text(' ${hotel.rating}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                          Expanded(child: Text(' (${hotel.reviews} отзывов)', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 9.5))),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text('от ${hotel.price} TMT', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                      const Text('/ ночь', style: TextStyle(color: AppColors.muted, fontSize: 9.5)),
                      const Spacer(),
                      const Divider(height: 1),
                      SizedBox(
                        height: 37,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: onReviews,
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                                child: Row(children: [const Icon(Icons.chat_bubble_outline_rounded, size: 16), Text(' ${hotel.reviews}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11))]),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              tooltip: 'Избранное',
                              visualDensity: VisualDensity.compact,
                              onPressed: onFavorite,
                              icon: Icon(isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 21, color: isFavorite ? AppColors.danger : AppColors.text),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final AvailabilityStatus status;

  Color get color => switch (status) {
        AvailabilityStatus.available => AppColors.success,
        AvailabilityStatus.unavailable => AppColors.danger,
        AvailabilityStatus.recheck => AppColors.warning,
        AvailabilityStatus.checking => AppColors.gold,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: color.withAlpha(32), borderRadius: BorderRadius.circular(13)),
      child: Text(status.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.w900)),
    );
  }
}

class _CatalogReviewCard extends StatelessWidget {
  const _CatalogReviewCard({required this.name, required this.date, required this.rating, required this.text});
  final String name;
  final String date;
  final int rating;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FB), borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 18, child: Icon(Icons.person_rounded, size: 20)),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
                    Text(date, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
                  ],
                ),
              ),
              const Icon(Icons.star_rounded, color: AppColors.gold, size: 19),
              Text('$rating.0', style: const TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 9),
          Text(text, style: const TextStyle(height: 1.4, fontSize: 12.5)),
        ],
      ),
    );
  }
}
