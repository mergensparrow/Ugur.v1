enum AvailabilityStatus { available, unavailable, recheck, checking }

extension AvailabilityStatusX on AvailabilityStatus {
  String get label => switch (this) {
        AvailabilityStatus.available => 'Номера есть',
        AvailabilityStatus.unavailable => 'Мест нет',
        AvailabilityStatus.recheck => 'Нужно перепроверить',
        AvailabilityStatus.checking => 'Проверяем сейчас',
      };
}

class RoomPrice {
  const RoomPrice(this.name, this.capacity, this.price, {this.tag});

  final String name;
  final String capacity;
  final int price;
  final String? tag;
}

class Hotel {
  const Hotel({
    required this.name,
    required this.city,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.status,
    required this.image,
    required this.description,
    required this.address,
    required this.amenities,
    required this.rooms,
  });

  final String name;
  final String city;
  final double rating;
  final int reviews;
  final int price;
  final AvailabilityStatus status;
  final String image;
  final String description;
  final String address;
  final List<String> amenities;
  final List<RoomPrice> rooms;
}

class NearbyHotel {
  const NearbyHotel({required this.hotelName, required this.distanceKm});

  final String hotelName;
  final double distanceKm;

  String get distanceLabel {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).round()} м';
    }
    final value = distanceKm == distanceKm.roundToDouble()
        ? distanceKm.toStringAsFixed(0)
        : distanceKm.toStringAsFixed(1);
    return '$value км';
  }
}

class TouristPlace {
  const TouristPlace({
    required this.name,
    required this.city,
    required this.image,
    required this.address,
    required this.description,
    required this.workingHours,
    required this.category,
    required this.nearbyHotels,
  });

  final String name;
  final String city;
  final String image;
  final String address;
  final String description;
  final String workingHours;
  final String category;
  final List<NearbyHotel> nearbyHotels;
}

class ProfileData {
  const ProfileData({
    required this.name,
    required this.phone,
    required this.email,
    required this.favoriteCities,
    required this.preferredPrice,
  });

  final String name;
  final String phone;
  final String email;
  final String favoriteCities;
  final String preferredPrice;

  ProfileData copyWith({
    String? name,
    String? phone,
    String? email,
    String? favoriteCities,
    String? preferredPrice,
  }) {
    return ProfileData(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      favoriteCities: favoriteCities ?? this.favoriteCities,
      preferredPrice: preferredPrice ?? this.preferredPrice,
    );
  }
}
