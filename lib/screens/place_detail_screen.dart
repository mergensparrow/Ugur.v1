import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'hotel_detail_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final TouristPlace place;

  void _openHotel(BuildContext context, String hotelName) {
    final hotel = hotelByName(hotelName);
    if (hotel == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HotelDetailScreen(hotel: hotel)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          place.name,
          style: const TextStyle(fontFamily: 'serif', fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 28 + MediaQuery.paddingOf(context).bottom),
        children: [
          AspectRatio(
            aspectRatio: 1.63,
            child: Image.asset(place.image, fit: BoxFit.cover, filterQuality: FilterQuality.high),
          ),
          Transform.translate(
            offset: const Offset(0, -14),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Container(
                          width: index == 0 ? 8 : 6,
                          height: index == 0 ? 8 : 6,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 0 ? AppColors.navy : const Color(0xFFD4D7DC),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 30,
                        height: 1,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -.7,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_outlined, size: 19),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            place.address,
                            style: const TextStyle(color: AppColors.muted, fontSize: 12.5, height: 1.35),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(place.description, style: const TextStyle(fontSize: 13.5, height: 1.5)),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.schedule_rounded, size: 20),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Время работы:', style: TextStyle(fontWeight: FontWeight.w900)),
                              const SizedBox(height: 2),
                              Text(place.workingHours, style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _PlaceBadges(place: place),
                    const SizedBox(height: 18),
                    const Text('Ближайшие гостиницы', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    if (place.nearbyHotels.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(18),
                          child: Text('Для этого места гостиницы пока не добавлены.', style: TextStyle(color: AppColors.muted)),
                        ),
                      )
                    else
                      ...place.nearbyHotels.map((nearby) {
                        final hotel = hotelByName(nearby.hotelName);
                        if (hotel == null) return const SizedBox.shrink();
                        return _NearbyHotelRow(
                          hotel: hotel,
                          distance: nearby.distanceLabel,
                          onTap: () => _openHotel(context, hotel.name),
                        );
                      }),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(color: const Color(0xFFEFF3F8), borderRadius: BorderRadius.circular(14)),
                      child: const Row(
                        children: [
                          Icon(Icons.lightbulb_outline_rounded, color: AppColors.muted),
                          SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              'Расстояния указаны от выбранного места приблизительно.',
                              style: TextStyle(color: AppColors.muted, fontSize: 11.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceBadges extends StatelessWidget {
  const _PlaceBadges({required this.place});
  final TouristPlace place;

  @override
  Widget build(BuildContext context) {
    final badges = <(IconData, String)>[
      (Icons.account_balance_outlined, place.category),
      (Icons.photo_camera_outlined, 'Отлично для фотографий'),
      (Icons.people_outline, 'Подходит для семьи'),
      (Icons.confirmation_number_outlined, 'Стоимость уточняется'),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4.2,
        crossAxisSpacing: 7,
        mainAxisSpacing: 7,
      ),
      itemCount: badges.length,
      itemBuilder: (_, index) {
        final badge = badges[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: const Color(0x66D3AA55)),
            color: const Color(0xFFFFFCF5),
          ),
          child: Row(
            children: [
              Icon(badge.$1, size: 16, color: AppColors.navy),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  badge.$2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NearbyHotelRow extends StatelessWidget {
  const _NearbyHotelRow({required this.hotel, required this.distance, required this.onTap});
  final Hotel hotel;
  final String distance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x12000000)))),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(hotel.image, width: 72, height: 62, fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hotel.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.gold, size: 16),
                        Text(' ${hotel.rating}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5)),
                        Text(' (${hotel.reviews} отзывов)', style: const TextStyle(color: AppColors.muted, fontSize: 9.5)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 13, color: AppColors.muted),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(hotel.address, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 9.5)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(distance, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ),
    );
  }
}
