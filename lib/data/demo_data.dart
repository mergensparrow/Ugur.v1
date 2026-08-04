import '../models/models.dart';

const cityNames = [
  'Ашхабад',
  'Аваза',
  'Туркменбаши',
  'Балканабат',
  'Дашогуз',
  'Туркменабад',
  'Мары',
  'Куняургенч',
  'Гызыларбат',
];

const cityHotelCounts = <String, int>{
  'Ашхабад': 87,
  'Аваза': 32,
  'Туркменбаши': 28,
  'Балканабат': 16,
  'Дашогуз': 16,
  'Туркменабад': 22,
  'Мары': 20,
  'Куняургенч': 9,
  'Гызыларбат': 8,
};

const hotels = [
  Hotel(
    name: 'Yyldyz Hotel',
    city: 'Ашхабад',
    rating: 4.8,
    reviews: 86,
    price: 850,
    status: AvailabilityStatus.available,
    image: 'assets/images/hotel_yyldyz.jpg',
    description: 'Премиальная гостиница с панорамным видом, ресторанами и современными удобствами.',
    address: 'Ашхабад, проспект Арчабил',
    amenities: ['Wi‑Fi', 'Парковка', 'Бассейн', 'Ресторан', 'Кондиционер', 'Завтрак'],
    rooms: [
      RoomPrice('Стандарт', '1 человек', 650),
      RoomPrice('Стандарт', '2 человека', 850, tag: 'Популярный выбор'),
      RoomPrice('Полулюкс', '2 человека', 1200),
      RoomPrice('Люкс', '2 человека', 1800),
      RoomPrice('Семейный', '4 человека', 2500, tag: 'Для семьи'),
    ],
  ),
  Hotel(
    name: 'Sport Hotel',
    city: 'Ашхабад',
    rating: 4.5,
    reviews: 42,
    price: 650,
    status: AvailabilityStatus.recheck,
    image: 'assets/images/hotel_sport.jpg',
    description: 'Практичная гостиница рядом со спортивной инфраструктурой.',
    address: 'Ашхабад, район Олимпийского городка',
    amenities: ['Wi‑Fi', 'Парковка', 'Ресторан', 'Кондиционер'],
    rooms: [
      RoomPrice('Стандарт', '1 человек', 650),
      RoomPrice('Полулюкс', '2 человека', 950),
    ],
  ),
  Hotel(
    name: 'Arçabil Hotel',
    city: 'Ашхабад',
    rating: 4.7,
    reviews: 64,
    price: 720,
    status: AvailabilityStatus.unavailable,
    image: 'assets/images/hotel_archabil.jpg',
    description: 'Современная городская гостиница с просторными номерами.',
    address: 'Ашхабад, улица Арчабил',
    amenities: ['Wi‑Fi', 'Парковка', 'Бассейн', 'Ресторан'],
    rooms: [
      RoomPrice('Стандарт', '1 человек', 720),
      RoomPrice('Люкс', '2 человека', 1650),
    ],
  ),
  Hotel(
    name: 'Oguzkent Hotel',
    city: 'Ашхабад',
    rating: 4.2,
    reviews: 87,
    price: 780,
    status: AvailabilityStatus.available,
    image: 'assets/images/city_ashgabat.jpg',
    description: 'Городская гостиница в центральной части Ашхабада.',
    address: 'Ашхабад, центральный район',
    amenities: ['Wi‑Fi', 'Парковка', 'Ресторан', 'Кондиционер', 'Завтрак'],
    rooms: [
      RoomPrice('Стандарт', '1 человек', 780),
      RoomPrice('Люкс', '2 человека', 1500),
    ],
  ),
  Hotel(
    name: 'Ak Altyn Hotel',
    city: 'Ашхабад',
    rating: 4.1,
    reviews: 74,
    price: 590,
    status: AvailabilityStatus.checking,
    image: 'assets/images/city_ashgabat.jpg',
    description: 'Уютная гостиница для деловых и туристических поездок.',
    address: 'Ашхабад, центральный район',
    amenities: ['Wi‑Fi', 'Парковка', 'Ресторан'],
    rooms: [
      RoomPrice('Стандарт', '1 человек', 590),
      RoomPrice('Стандарт', '2 человека', 740),
    ],
  ),
  Hotel(
    name: 'Avaza Grand Hotel',
    city: 'Аваза',
    rating: 4.6,
    reviews: 51,
    price: 900,
    status: AvailabilityStatus.available,
    image: 'assets/images/city_avaza.jpg',
    description: 'Курортная гостиница у моря с пляжной зоной.',
    address: 'Национальная туристическая зона Аваза',
    amenities: ['Wi‑Fi', 'Парковка', 'Бассейн', 'Ресторан', 'Завтрак'],
    rooms: [
      RoomPrice('Стандарт', '2 человека', 900),
      RoomPrice('Семейный', '4 человека', 1650),
    ],
  ),
  Hotel(
    name: 'Hazyna Hotel',
    city: 'Аваза',
    rating: 4.3,
    reviews: 33,
    price: 720,
    status: AvailabilityStatus.recheck,
    image: 'assets/images/city_avaza.jpg',
    description: 'Спокойная курортная гостиница для семейного отдыха.',
    address: 'Аваза, прибрежная зона',
    amenities: ['Wi‑Fi', 'Бассейн', 'Ресторан', 'Кондиционер'],
    rooms: [
      RoomPrice('Стандарт', '2 человека', 720),
      RoomPrice('Люкс', '2 человека', 1300),
    ],
  ),
  Hotel(
    name: 'Turkmenbashi Hotel',
    city: 'Туркменбаши',
    rating: 4.4,
    reviews: 38,
    price: 610,
    status: AvailabilityStatus.available,
    image: 'assets/images/city_turkmenbashi.jpg',
    description: 'Гостиница рядом с городской и портовой инфраструктурой.',
    address: 'Туркменбаши, центр города',
    amenities: ['Wi‑Fi', 'Парковка', 'Ресторан', 'Кондиционер'],
    rooms: [
      RoomPrice('Стандарт', '1 человек', 610),
      RoomPrice('Стандарт', '2 человека', 760),
    ],
  ),
  Hotel(
    name: 'Hazar Hotel',
    city: 'Туркменбаши',
    rating: 4.2,
    reviews: 29,
    price: 540,
    status: AvailabilityStatus.checking,
    image: 'assets/images/city_turkmenbashi.jpg',
    description: 'Компактная гостиница для коротких поездок.',
    address: 'Туркменбаши, прибрежный район',
    amenities: ['Wi‑Fi', 'Парковка', 'Кондиционер'],
    rooms: [
      RoomPrice('Стандарт', '1 человек', 540),
      RoomPrice('Стандарт', '2 человека', 680),
    ],
  ),
  Hotel(
    name: 'Mary Hotel',
    city: 'Мары',
    rating: 4.5,
    reviews: 47,
    price: 560,
    status: AvailabilityStatus.unavailable,
    image: 'assets/images/city_mary.jpg',
    description: 'Городская гостиница для туристических и деловых поездок.',
    address: 'Мары, центр города',
    amenities: ['Wi‑Fi', 'Парковка', 'Ресторан', 'Кондиционер'],
    rooms: [
      RoomPrice('Стандарт', '1 человек', 560),
      RoomPrice('Люкс', '2 человека', 980),
    ],
  ),
  Hotel(
    name: 'Merv Hotel',
    city: 'Мары',
    rating: 4.1,
    reviews: 31,
    price: 430,
    status: AvailabilityStatus.recheck,
    image: 'assets/images/city_mary.jpg',
    description: 'Небольшая гостиница с базовыми удобствами.',
    address: 'Мары, городской район',
    amenities: ['Wi‑Fi', 'Парковка', 'Кондиционер'],
    rooms: [
      RoomPrice('Стандарт', '1 человек', 430),
      RoomPrice('Стандарт', '2 человека', 570),
    ],
  ),
  Hotel(
    name: 'Dashoguz Hotel',
    city: 'Дашогуз',
    rating: 4.3,
    reviews: 36,
    price: 500,
    status: AvailabilityStatus.recheck,
    image: 'assets/images/city_dashoguz.jpg',
    description: 'Удобная гостиница в городской части Дашогуза.',
    address: 'Дашогуз, центр города',
    amenities: ['Wi‑Fi', 'Парковка', 'Ресторан'],
    rooms: [
      RoomPrice('Стандарт', '1 человек', 500),
      RoomPrice('Люкс', '2 человека', 890),
    ],
  ),
  Hotel(
    name: 'Shabat Hotel',
    city: 'Дашогуз',
    rating: 4.0,
    reviews: 24,
    price: 390,
    status: AvailabilityStatus.checking,
    image: 'assets/images/city_dashoguz.jpg',
    description: 'Доступная гостиница для короткого пребывания.',
    address: 'Дашогуз, городской район',
    amenities: ['Wi‑Fi', 'Парковка'],
    rooms: [
      RoomPrice('Стандарт', '1 человек', 390),
      RoomPrice('Стандарт', '2 человека', 520),
    ],
  ),
  Hotel(
    name: 'Turkmenabat Hotel',
    city: 'Туркменабад',
    rating: 4.4,
    reviews: 44,
    price: 520,
    status: AvailabilityStatus.available,
    image: 'assets/images/city_turkmenabat.jpg',
    description: 'Современная гостиница в центре Туркменабада.',
    address: 'Туркменабад, центр города',
    amenities: ['Wi‑Fi', 'Парковка', 'Ресторан', 'Кондиционер'],
    rooms: [
      RoomPrice('Стандарт', '1 человек', 520),
      RoomPrice('Люкс', '2 человека', 940),
    ],
  ),
  Hotel(
    name: 'Amul Hotel',
    city: 'Туркменабад',
    rating: 4.1,
    reviews: 28,
    price: 410,
    status: AvailabilityStatus.recheck,
    image: 'assets/images/city_turkmenabat.jpg',
    description: 'Спокойная гостиница с необходимыми удобствами.',
    address: 'Туркменабад, городской район',
    amenities: ['Wi‑Fi', 'Парковка', 'Кондиционер'],
    rooms: [
      RoomPrice('Стандарт', '1 человек', 410),
      RoomPrice('Стандарт', '2 человека', 550),
    ],
  ),
  Hotel(
    name: 'Balkan Hotel',
    city: 'Балканабат',
    rating: 4.2,
    reviews: 27,
    price: 470,
    status: AvailabilityStatus.available,
    image: 'assets/images/city_balkanabat.jpg',
    description: 'Городская гостиница в Балканабате.',
    address: 'Балканабат, центр города',
    amenities: ['Wi‑Fi', 'Парковка', 'Ресторан'],
    rooms: [
      RoomPrice('Стандарт', '1 человек', 470),
      RoomPrice('Стандарт', '2 человека', 610),
    ],
  ),
  Hotel(
    name: 'Nebit Hotel',
    city: 'Балканабат',
    rating: 3.9,
    reviews: 19,
    price: 350,
    status: AvailabilityStatus.checking,
    image: 'assets/images/city_balkanabat.jpg',
    description: 'Практичный вариант размещения в Балканабате.',
    address: 'Балканабат, городской район',
    amenities: ['Wi‑Fi', 'Парковка'],
    rooms: [
      RoomPrice('Стандарт', '1 человек', 350),
      RoomPrice('Стандарт', '2 человека', 470),
    ],
  ),
];

const touristPlacesByCity = <String, List<TouristPlace>>{
  'Ашхабад': [
    TouristPlace(
      name: 'Alem Center',
      city: 'Ашхабад',
      image: 'assets/images/place_alem.jpg',
      address: 'проспект Арчабил, Ашхабад, Туркменистан',
      description: 'Культурно-развлекательный центр и один из заметных символов современного Ашхабада. Здесь расположены общественные пространства и смотровая площадка.',
      workingHours: 'Ежедневно с 10:00 до 22:00',
      category: 'Культурный центр',
      nearbyHotels: [
        NearbyHotel(hotelName: 'Yyldyz Hotel', distanceKm: 0.8),
        NearbyHotel(hotelName: 'Sport Hotel', distanceKm: 1.2),
        NearbyHotel(hotelName: 'Arçabil Hotel', distanceKm: 1.8),
        NearbyHotel(hotelName: 'Oguzkent Hotel', distanceKm: 2.4),
        NearbyHotel(hotelName: 'Ak Altyn Hotel', distanceKm: 2.9),
      ],
    ),
    TouristPlace(
      name: 'Монумент Нейтралитета',
      city: 'Ашхабад',
      image: 'assets/images/place_monument.jpg',
      address: 'Ашхабад, Туркменистан',
      description: 'Монументальный архитектурный комплекс и популярное место для прогулок и фотографий.',
      workingHours: 'Открытая территория',
      category: 'Памятник',
      nearbyHotels: [
        NearbyHotel(hotelName: 'Yyldyz Hotel', distanceKm: 1.2),
        NearbyHotel(hotelName: 'Arçabil Hotel', distanceKm: 1.7),
        NearbyHotel(hotelName: 'Oguzkent Hotel', distanceKm: 2.1),
      ],
    ),
    TouristPlace(
      name: 'Арка Нейтралитета',
      city: 'Ашхабад',
      image: 'assets/images/place_arch.jpg',
      address: 'Ашхабад, Туркменистан',
      description: 'Известная архитектурная достопримечательность столицы с благоустроенной территорией.',
      workingHours: 'Открытая территория',
      category: 'Архитектура',
      nearbyHotels: [
        NearbyHotel(hotelName: 'Sport Hotel', distanceKm: 1.0),
        NearbyHotel(hotelName: 'Yyldyz Hotel', distanceKm: 1.6),
        NearbyHotel(hotelName: 'Ak Altyn Hotel', distanceKm: 2.3),
      ],
    ),
    TouristPlace(
      name: 'Парк Независимости',
      city: 'Ашхабад',
      image: 'assets/images/place_park.jpg',
      address: 'Ашхабад, Туркменистан',
      description: 'Большая зелёная зона для прогулок и отдыха рядом с городскими достопримечательностями.',
      workingHours: 'Ежедневно',
      category: 'Парк',
      nearbyHotels: [
        NearbyHotel(hotelName: 'Arçabil Hotel', distanceKm: 1.4),
        NearbyHotel(hotelName: 'Yyldyz Hotel', distanceKm: 2.0),
        NearbyHotel(hotelName: 'Sport Hotel', distanceKm: 2.5),
      ],
    ),
  ],
  'Аваза': [
    TouristPlace(
      name: 'Набережная Авазы',
      city: 'Аваза',
      image: 'assets/images/city_avaza.jpg',
      address: 'Аваза, Туркменистан',
      description: 'Прибрежная прогулочная зона с курортной инфраструктурой.',
      workingHours: 'Ежедневно',
      category: 'Набережная',
      nearbyHotels: [
        NearbyHotel(hotelName: 'Avaza Grand Hotel', distanceKm: 0.5),
        NearbyHotel(hotelName: 'Hazyna Hotel', distanceKm: 1.1),
      ],
    ),
    TouristPlace(
      name: 'Пляж Авазы',
      city: 'Аваза',
      image: 'assets/images/city_avaza.jpg',
      address: 'Аваза, побережье Каспийского моря',
      description: 'Курортная пляжная зона для отдыха у моря.',
      workingHours: 'Ежедневно',
      category: 'Пляж',
      nearbyHotels: [
        NearbyHotel(hotelName: 'Hazyna Hotel', distanceKm: 0.4),
        NearbyHotel(hotelName: 'Avaza Grand Hotel', distanceKm: 0.9),
      ],
    ),
  ],
  'Туркменбаши': [
    TouristPlace(
      name: 'Приморская набережная',
      city: 'Туркменбаши',
      image: 'assets/images/city_turkmenbashi.jpg',
      address: 'Туркменбаши, Туркменистан',
      description: 'Городская прогулочная зона с видом на побережье.',
      workingHours: 'Ежедневно',
      category: 'Набережная',
      nearbyHotels: [
        NearbyHotel(hotelName: 'Turkmenbashi Hotel', distanceKm: 0.7),
        NearbyHotel(hotelName: 'Hazar Hotel', distanceKm: 1.3),
      ],
    ),
  ],
  'Мары': [
    TouristPlace(
      name: 'Исторический комплекс Мерв',
      city: 'Мары',
      image: 'assets/images/city_mary.jpg',
      address: 'Марыйский велаят, Туркменистан',
      description: 'Историческая территория рядом с городом Мары.',
      workingHours: 'Ежедневно',
      category: 'История',
      nearbyHotels: [
        NearbyHotel(hotelName: 'Mary Hotel', distanceKm: 2.0),
        NearbyHotel(hotelName: 'Merv Hotel', distanceKm: 2.8),
      ],
    ),
  ],
  'Дашогуз': [
    TouristPlace(
      name: 'Центральная площадь',
      city: 'Дашогуз',
      image: 'assets/images/city_dashoguz.jpg',
      address: 'Дашогуз, Туркменистан',
      description: 'Городское общественное пространство для прогулок.',
      workingHours: 'Ежедневно',
      category: 'Городское место',
      nearbyHotels: [
        NearbyHotel(hotelName: 'Dashoguz Hotel', distanceKm: 0.6),
        NearbyHotel(hotelName: 'Shabat Hotel', distanceKm: 1.4),
      ],
    ),
  ],
  'Туркменабад': [
    TouristPlace(
      name: 'Набережная Амударьи',
      city: 'Туркменабад',
      image: 'assets/images/city_turkmenabat.jpg',
      address: 'Туркменабад, Туркменистан',
      description: 'Прогулочная зона в городе Туркменабад.',
      workingHours: 'Ежедневно',
      category: 'Набережная',
      nearbyHotels: [
        NearbyHotel(hotelName: 'Turkmenabat Hotel', distanceKm: 0.9),
        NearbyHotel(hotelName: 'Amul Hotel', distanceKm: 1.6),
      ],
    ),
  ],
  'Балканабат': [
    TouristPlace(
      name: 'Центральный парк',
      city: 'Балканабат',
      image: 'assets/images/city_balkanabat.jpg',
      address: 'Балканабат, Туркменистан',
      description: 'Зелёная городская зона для прогулок.',
      workingHours: 'Ежедневно',
      category: 'Парк',
      nearbyHotels: [
        NearbyHotel(hotelName: 'Balkan Hotel', distanceKm: 0.8),
        NearbyHotel(hotelName: 'Nebit Hotel', distanceKm: 1.5),
      ],
    ),
  ],
};

List<Hotel> hotelsForCity(String city) =>
    hotels.where((hotel) => hotel.city == city).toList(growable: false);

Hotel? hotelByName(String name) {
  for (final hotel in hotels) {
    if (hotel.name == name) return hotel;
  }
  return null;
}

List<TouristPlace> placesForCity(String city) {
  final places = touristPlacesByCity[city];
  if (places != null && places.isNotEmpty) return places;
  return [
    TouristPlace(
      name: 'Центр города $city',
      city: city,
      image: _cityAsset(city),
      address: '$city, Туркменистан',
      description: 'Популярное городское место. Подробная информация будет добавлена через панель администратора.',
      workingHours: 'Ежедневно',
      category: 'Городское место',
      nearbyHotels: hotelsForCity(city)
          .take(5)
          .toList()
          .asMap()
          .entries
          .map((entry) => NearbyHotel(
                hotelName: entry.value.name,
                distanceKm: 0.8 + entry.key * 0.7,
              ))
          .toList(),
    ),
  ];
}

String popularPlacesTitle(String city) {
  const forms = <String, String>{
    'Ашхабад': 'Ашхабада',
    'Аваза': 'Авазы',
    'Туркменбаши': 'Туркменбаши',
    'Балканабат': 'Балканабата',
    'Дашогуз': 'Дашогуза',
    'Туркменабад': 'Туркменабада',
    'Мары': 'Мары',
    'Куняургенч': 'Куняургенча',
    'Гызыларбат': 'Гызыларбата',
  };
  return 'Популярные места ${forms[city] ?? city}';
}

String _cityAsset(String city) => switch (city) {
      'Ашхабад' => 'assets/images/city_ashgabat.jpg',
      'Аваза' => 'assets/images/city_avaza.jpg',
      'Туркменбаши' => 'assets/images/city_turkmenbashi.jpg',
      'Балканабат' => 'assets/images/city_balkanabat.jpg',
      'Дашогуз' => 'assets/images/city_dashoguz.jpg',
      'Туркменабад' => 'assets/images/city_turkmenabat.jpg',
      'Мары' => 'assets/images/city_mary.jpg',
      _ => 'assets/images/city_ashgabat.jpg',
    };
