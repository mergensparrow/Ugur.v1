import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../data/demo_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/mockup_image_slice.dart';
import 'city_picker_screen.dart';
import 'hotel_catalog_screen.dart';
import 'notifications_screen.dart';
import 'place_detail_screen.dart';
import 'ui_settings_screen.dart';

Widget _approvedPlacePhoto(String name) {
  final rect = switch (name) {
    'Монумент Нейтралитета' => const Rect.fromLTWH(31, 759, 167, 276),
    'Alem Center' => const Rect.fromLTWH(207, 759, 168, 276),
    'Арка Нейтралитета' => const Rect.fromLTWH(386, 759, 168, 276),
    'Парк Независимости' => const Rect.fromLTWH(563, 759, 148, 276),
    _ => null,
  };
  if (rect == null) {
    final place = touristPlacesByCity.values
        .expand((items) => items)
        .firstWhere((item) => item.name == name);
    return Image.asset(place.image, fit: BoxFit.cover);
  }
  return MockupImageSlice(
    asset: 'assets/images/mockup_home_main.jpeg',
    sourceSize: const Size(711, 1536),
    sourceRect: rect,
  );
}

Widget _approvedDestinationPhoto(String name, String fallbackAsset) {
  if (name == 'Мары') {
    return const MockupImageSlice(
      asset: 'assets/images/mockup_favorites.jpeg',
      sourceSize: Size(853, 1844),
      sourceRect: Rect.fromLTWH(55, 925, 244, 248),
    );
  }
  final rect = switch (name) {
    'Аваза' => const Rect.fromLTWH(50, 303, 754, 374),
    'Туркменбаши' => const Rect.fromLTWH(50, 808, 368, 210),
    'Дашогуз' => const Rect.fromLTWH(434, 808, 370, 210),
    _ => null,
  };
  if (rect == null) return Image.asset(fallbackAsset, fit: BoxFit.cover);
  return MockupImageSlice(
    asset: 'assets/images/mockup_home_lower.jpeg',
    sourceSize: const Size(853, 1844),
    sourceRect: rect,
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCity = 'Ашхабад';
  int _logoTapCount = 0;
  DateTime? _lastLogoTapAt;

  static const popularCities = <_CityCardData>[
    _CityCardData('Аваза', 'Курортная зона · 32 гостиницы', 'assets/images/city_avaza.jpg'),
    _CityCardData('Туркменбаши', 'Портовый город · 22 гостиницы', 'assets/images/city_turkmenbashi.jpg'),
    _CityCardData('Дашогуз', 'Исторический город · 16 гостиниц', 'assets/images/city_dashoguz.jpg'),
    _CityCardData('Мары', 'Древний Мерв · 20 гостиниц', 'assets/images/city_mary.jpg'),
  ];

  static const otherCities = <_SmallCityData>[
    _SmallCityData('Балканабат', Color(0xFFFFF3DB), Color(0xFFD69B22)),
    _SmallCityData('Мары', Color(0xFFF1ECFF), Color(0xFF7753D2)),
    _SmallCityData('Туркменабад', Color(0xFFEAF7EE), Color(0xFF2F9C58)),
    _SmallCityData('Дашогуз', Color(0xFFEAF5FF), Color(0xFF2D8ECC)),
  ];


  void _handleLogoTap() {
    final now = DateTime.now();
    if (_lastLogoTapAt == null || now.difference(_lastLogoTapAt!) > const Duration(seconds: 2)) {
      _logoTapCount = 0;
    }
    _lastLogoTapAt = now;
    _logoTapCount += 1;
    if (_logoTapCount < 5) return;
    _logoTapCount = 0;
    showUiDesignerSheet(context);
  }

  List<TouristPlace> _orderedPlaces() {
    final result = List<TouristPlace>.from(placesForCity(selectedCity));
    if (selectedCity == 'Ашхабад') {
      const order = <String, int>{
        'Монумент Нейтралитета': 0,
        'Alem Center': 1,
        'Арка Нейтралитета': 2,
        'Парк Независимости': 3,
      };
      result.sort((a, b) => (order[a.name] ?? 99).compareTo(order[b.name] ?? 99));
    }
    return result;
  }

  Future<void> _pickCity() async {
    final value = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => CityPickerScreen(initialCity: selectedCity)),
    );
    if (value != null && mounted) setState(() => selectedCity = value);
  }

  void _openCatalog([String? city]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HotelCatalogScreen(city: city ?? selectedCity)),
    );
  }

  void _openNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const NotificationsScreen(showBackButton: true)),
    );
  }

  void _openPlace(TouristPlace place) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: place)),
    );
  }

  void _showAllPlaces() {
    final places = _orderedPlaces();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                popularPlacesTitle(selectedCity),
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 24,
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              ...places.map(
                (place) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: const Color(0xFFF9FAFD),
                    borderRadius: BorderRadius.circular(18),
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(sheetContext);
                        _openPlace(place);
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.asset(place.image, width: 64, height: 64, fit: BoxFit.cover),
                      ),
                      title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: Text(place.category),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.navy),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (_, __) {
        final places = _orderedPlaces();
        final compact = context.isCompactLayout;
        final tuning = AppState.instance;
        final basePanelGap = compact ? 8.0 : 12.0;
        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(compact ? 9 : 14, compact ? 11 : 14, compact ? 9 : 14, 0),
                child: _TopBrand(
                  onNotifications: _openNotifications,
                  onLogoTap: _handleLogoTap,
                ),
              ),
              SizedBox(height: basePanelGap * tuning.homePanelGapScale),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, _) => ListView(
                    padding: EdgeInsets.fromLTRB(compact ? 6 : 14, 0, compact ? 6 : 14, 20),
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        heightFactor: 1,
                        child: _CityDiscoveryPanel(
                          selectedCity: selectedCity,
                          places: places,
                          contentTopOffset: tuning.homeContentOffset,
                          cardsScale: tuning.homeCardsScale,
                          bottomSpace: tuning.homePanelBottomSpace,
                          onPickCity: _pickCity,
                          onOpenPlace: _openPlace,
                          onShowAllPlaces: _showAllPlaces,
                          onSearchHotels: () => _openCatalog(),
                        ),
                      ),
                      SizedBox(height: compact ? 12 : 18),
                      _CountryDiscoveryPanel(
                        popularCities: popularCities,
                        otherCities: otherCities,
                        onOpenCity: _openCatalog,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


class _UgurMark extends StatelessWidget {
  const _UgurMark({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CustomPaint(painter: _UgurMarkPainter()),
    );
  }
}

class _UgurMarkPainter extends CustomPainter {
  const _UgurMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .15
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(size.width * .22, size.height * .12)
      ..lineTo(size.width * .22, size.height * .62)
      ..cubicTo(
        size.width * .22,
        size.height * .84,
        size.width * .64,
        size.height * .84,
        size.width * .64,
        size.height * .62,
      )
      ..lineTo(size.width * .64, size.height * .24);
    canvas.drawPath(path, paint);
    canvas.drawCircle(
      Offset(size.width * .64, size.height * .12),
      size.width * .055,
      Paint()..color = AppColors.gold,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TopBrand extends StatelessWidget {
  const _TopBrand({required this.onNotifications, required this.onLogoTap});
  final VoidCallback onNotifications;
  final VoidCallback onLogoTap;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: compact ? 3 : 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onLogoTap,
              child: Row(
                children: [
                  _UgurMark(size: compact ? 38 : 48),
                  SizedBox(width: compact ? 5 : 7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ugur',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: compact ? 28 : 34,
                            height: .9,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: compact ? 3 : 7),
                        Text(
                          'ГОСТИНИЦЫ ТУРКМЕНИСТАНА',
                          style: TextStyle(
                            fontSize: compact ? 8 : 9.5,
                            letterSpacing: .35,
                            color: AppColors.muted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: AppState.instance,
            builder: (_, __) {
              final unread = AppState.instance.unreadNotifications;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: onNotifications,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: compact ? 40 : 54,
                        height: compact ? 40 : 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.navy,
                          size: compact ? 24 : 30,
                        ),
                      ),
                    ),
                  ),
                  if (unread > 0)
                    Positioned(
                      right: -4,
                      top: -5,
                      child: Container(
                        width: compact ? 19 : 23,
                        height: compact ? 19 : 23,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                        child: Text(
                          '$unread',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: compact ? 9 : 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CityDiscoveryPanel extends StatefulWidget {
  const _CityDiscoveryPanel({
    required this.selectedCity,
    required this.places,
    required this.contentTopOffset,
    required this.cardsScale,
    required this.bottomSpace,
    required this.onPickCity,
    required this.onOpenPlace,
    required this.onShowAllPlaces,
    required this.onSearchHotels,
  });

  final String selectedCity;
  final List<TouristPlace> places;
  final double contentTopOffset;
  final double cardsScale;
  final double bottomSpace;
  final VoidCallback onPickCity;
  final ValueChanged<TouristPlace> onOpenPlace;
  final VoidCallback onShowAllPlaces;
  final VoidCallback onSearchHotels;

  @override
  State<_CityDiscoveryPanel> createState() => _CityDiscoveryPanelState();
}

class _CityDiscoveryPanelState extends State<_CityDiscoveryPanel> {
  static const double _placeViewportFraction = .272;
  late final PageController _placesController = PageController(
    viewportFraction: _placeViewportFraction,
  );

  @override
  void didUpdateWidget(covariant _CityDiscoveryPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCity != widget.selectedCity) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _placesController.hasClients) {
          _placesController.jumpToPage(0);
        }
      });
    }
  }

  @override
  void dispose() {
    _placesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    // The panel must shrink-wrap its content. A fixed height creates a large
    // empty blue area after the search button, especially in iOS Home Screen
    // mode where the available viewport differs from ordinary Safari.
    return Container(
      key: const ValueKey('home-city-discovery-panel'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
        border: Border.all(color: const Color(0x33CDA344)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, .45, 1],
          colors: [Color(0xFFF9FCFF), Color(0xFFF1F7FF), Color(0xFFE6F1FF)],
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x15031B4E), blurRadius: 28, offset: Offset(0, 12)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: CustomPaint(
          painter: const _DiscoveryDecorationPainter(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              compact ? 16 : 20,
              (compact ? 34 : 40) + widget.contentTopOffset,
              compact ? 14 : 20,
              (compact ? 18 : 24) + widget.bottomSpace,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                    'Куда вы хотите\nпоехать?',
                    style: TextStyle(
                      fontSize: compact ? 25.5 : 36,
                      height: 1.02,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.9,
                      color: AppColors.navy,
                    ),
                  ),
                  SizedBox(height: compact ? 10 : 15),
                  Text(
                    'Выберите город и посмотрите,\nчто интересного рядом',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: compact ? 11.5 : 14.5,
                      height: 1.42,
                    ),
                  ),
                  SizedBox(height: compact ? 49 : 46),
                  Material(
                    color: Colors.white,
                    elevation: 0,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      onTap: widget.onPickCity,
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        height: compact ? 60 : 86,
                        padding: EdgeInsets.symmetric(horizontal: compact ? 11 : 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0x11031B4E)),
                          boxShadow: const [
                            BoxShadow(color: Color(0x10031B4E), blurRadius: 18, offset: Offset(0, 7)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: compact ? 40 : 54,
                              height: compact ? 40 : 54,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFF0C9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.location_on_rounded,
                                color: AppColors.gold,
                                size: compact ? 27 : 34,
                              ),
                            ),
                            SizedBox(width: compact ? 10 : 14),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Выберите город',
                                    style: TextStyle(
                                      color: const Color(0xFFB48726),
                                      fontSize: compact ? 10.5 : 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: compact ? 2 : 4),
                                  SizedBox(
                                    width: double.infinity,
                                    height: compact ? 20 : 28,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.selectedCity,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: compact ? 19.5 : 27,
                                          height: 1,
                                          color: AppColors.navy,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: compact ? 23 : 31,
                              color: AppColors.navy,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: compact ? 11 : 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          popularPlacesTitle(widget.selectedCity),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: compact ? 13.1 : 20,
                            height: 1.05,
                            color: AppColors.navy,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: widget.onShowAllPlaces,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFB18426),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                        child: Text(
                          'Смотреть все',
                          style: TextStyle(fontSize: compact ? 9.7 : 12.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: compact ? 18 : 16),
                  SizedBox(
                    height: (compact ? 203 : 235) * widget.cardsScale,
                    child: PageView.builder(
                      controller: _placesController,
                      padEnds: false,
                      physics: const PageScrollPhysics(),
                      itemCount: widget.places.length,
                      itemBuilder: (_, index) => Padding(
                        padding: EdgeInsets.only(right: compact ? 7 : 10),
                        child: _PlaceCard(
                          place: widget.places[index],
                          highlighted: widget.places[index].name == 'Alem Center',
                          onTap: () => widget.onOpenPlace(widget.places[index]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: compact ? 10 : 17),
                  Center(
                    child: _SwipeProgressIndicator(
                      controller: _placesController,
                      itemCount: widget.places.length,
                      viewportFraction: _placeViewportFraction,
                    ),
                  ),
                  SizedBox(height: compact ? 14 : 20),
                  FilledButton.icon(
                    onPressed: widget.onSearchHotels,
                    icon: Icon(Icons.search_rounded, size: compact ? 22 : 27),
                    label: Text(
                      'Найти гостиницы',
                      style: TextStyle(fontSize: compact ? 14.5 : 17),
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: Size.fromHeight(compact ? 48 : 60),
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

class _DiscoveryDecorationPainter extends CustomPainter {
  const _DiscoveryDecorationPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final skyline = Paint()
      ..color = const Color(0x4A7FA6D2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeJoin = StrokeJoin.round;
    final skylineFill = Paint()
      ..color = const Color(0x0E7FA6D2)
      ..style = PaintingStyle.fill;
    final baseY = size.height * .345;

    void drawBuilding(
      double xFactor,
      double widthFactor,
      double heightFactor, {
      bool dome = false,
      bool antenna = false,
    }) {
      final left = size.width * xFactor;
      final width = size.width * widthFactor;
      final height = size.height * heightFactor;
      final top = baseY - height;
      final outline = Path()..moveTo(left, baseY);
      if (dome) {
        outline
          ..lineTo(left, top + height * .18)
          ..quadraticBezierTo(left + width * .5, top - height * .10, left + width, top + height * .18)
          ..lineTo(left + width, baseY);
      } else {
        outline
          ..lineTo(left, top)
          ..lineTo(left + width, top)
          ..lineTo(left + width, baseY);
      }
      canvas.drawPath(outline, skyline);
      canvas.drawRect(Rect.fromLTRB(left, top + height * .22, left + width, baseY), skylineFill);
      if (antenna) {
        canvas.drawLine(
          Offset(left + width * .5, top),
          Offset(left + width * .5, top - height * .30),
          skyline,
        );
        canvas.drawCircle(Offset(left + width * .5, top - height * .06), width * .08, skyline);
      }
      for (var i = 1; i < 3; i++) {
        final windowX = left + width * i / 3;
        canvas.drawLine(
          Offset(windowX, top + height * .30),
          Offset(windowX, baseY),
          skyline,
        );
      }
      canvas.drawLine(
        Offset(left, baseY - height * .34),
        Offset(left + width, baseY - height * .34),
        skyline,
      );
    }

    drawBuilding(.47, .055, .09, dome: true);
    drawBuilding(.515, .065, .145, antenna: true);
    drawBuilding(.575, .075, .19, dome: true);
    drawBuilding(.645, .060, .255, antenna: true);
    drawBuilding(.700, .082, .165, dome: true);
    drawBuilding(.775, .055, .225, antenna: true);
    drawBuilding(.825, .072, .135, dome: true);
    drawBuilding(.892, .055, .18, antenna: true);
    drawBuilding(.942, .065, .11, dome: true);
    canvas.drawLine(Offset(size.width * .45, baseY), Offset(size.width, baseY), skyline);

    final route = Paint()
      ..color = const Color(0xC7C59533)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.45;
    final path = Path()
      ..moveTo(size.width * .47, size.height * .13)
      ..cubicTo(size.width * .72, size.height * .14, size.width * .55, size.height * .27, size.width * .17, size.height * .31)
      ..cubicTo(size.width * -.02, size.height * .34, size.width * .02, size.height * .46, size.width * .78, size.height * .50)
      ..cubicTo(size.width * .91, size.height * .51, size.width * .82, size.height * .55, size.width * .74, size.height * .57);
    canvas.drawPath(path, route);

    final dot = Paint()..color = const Color(0xFFC59635);
    final whiteDot = Paint()..color = Colors.white;
    for (final point in [
      Offset(size.width * .47, size.height * .13),
      Offset(size.width * .17, size.height * .31),
      Offset(size.width * .74, size.height * .57),
    ]) {
      canvas.drawCircle(point, 5.1, dot);
      canvas.drawCircle(point, 2.0, whiteDot);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SwipeProgressIndicator extends StatelessWidget {
  const _SwipeProgressIndicator({
    required this.controller,
    required this.itemCount,
    required this.viewportFraction,
  });

  final PageController controller;
  final int itemCount;
  final double viewportFraction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      height: 4,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final page = controller.hasClients
              ? (controller.page ?? controller.initialPage.toDouble())
              : controller.initialPage.toDouble();
          final visibleItems = 1 / viewportFraction;
          final maxPage = itemCount > visibleItems ? itemCount - visibleItems : 0.0;
          final progress = maxPage > 0 ? (page / maxPage).clamp(0.0, 1.0).toDouble() : 0.0;
          const thumbWidth = 36.0;
          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFFC7D8EC),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Positioned(
                left: progress * (108 - thumbWidth),
                child: Container(
                  width: thumbWidth,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD6A324), Color(0xFFF0CC6A)],
                    ),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.place, required this.onTap, required this.highlighted});

  final TouristPlace place;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: highlighted ? AppColors.gold : AppColors.border,
              width: highlighted ? 2 : 1,
            ),
            boxShadow: const [
              BoxShadow(color: Color(0x11031B4E), blurRadius: 13, offset: Offset(0, 5)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _approvedPlacePhoto(place.name)),
                Container(
                  height: compact ? 36 : 58,
                  padding: EdgeInsets.fromLTRB(compact ? 6 : 11, 4, 5, 3),
                  color: Colors.white,
                  child: Text(
                    place.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: compact ? 9.6 : 13.5,
                      height: 1.12,
                      fontWeight: FontWeight.w700,
                    ),
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

class _CountryDiscoveryPanel extends StatefulWidget {
  const _CountryDiscoveryPanel({
    required this.popularCities,
    required this.otherCities,
    required this.onOpenCity,
  });

  final List<_CityCardData> popularCities;
  final List<_SmallCityData> otherCities;
  final ValueChanged<String> onOpenCity;

  @override
  State<_CountryDiscoveryPanel> createState() => _CountryDiscoveryPanelState();
}

class _CountryDiscoveryPanelState extends State<_CountryDiscoveryPanel> {
  static const _pageLayouts = <List<int>>[
    [0, 1, 2],
    [1, 2, 3],
    [2, 3, 0],
  ];

  final PageController _destinationsController = PageController();
  int _activePage = 0;

  @override
  void dispose() {
    _destinationsController.dispose();
    super.dispose();
  }

  void _showAllDestinations(BuildContext context) {
    final combined = <_CityCardData>[...widget.popularCities];
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Популярные направления',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 24,
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              ...combined.map(
                (city) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(city.asset, width: 58, height: 58, fit: BoxFit.cover),
                  ),
                  title: Text(city.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(city.subtitle),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    widget.onOpenCity(city.name);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return Container(
      padding: EdgeInsets.fromLTRB(
        compact ? 12 : 17,
        compact ? 16 : 23,
        compact ? 12 : 17,
        compact ? 14 : 21,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x12031B4E), blurRadius: 24, offset: Offset(0, 9))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: compact ? 21 : 30,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Популярные направления',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: compact ? 14.5 : 20,
                        color: AppColors.navy,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _showAllDestinations(context),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFB18426),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
                ),
                child: Text('Смотреть все', style: TextStyle(fontSize: compact ? 9.8 : 14)),
              ),
            ],
          ),
          SizedBox(height: compact ? 6 : 12),
          SizedBox(
            height: compact ? 304 : 426,
            child: PageView.builder(
              controller: _destinationsController,
              itemCount: _pageLayouts.length,
              physics: const PageScrollPhysics(),
              onPageChanged: (value) => setState(() => _activePage = value),
              itemBuilder: (_, pageIndex) {
                final layout = _pageLayouts[pageIndex];
                final featured = widget.popularCities[layout[0]];
                final firstSmall = widget.popularCities[layout[1]];
                final secondSmall = widget.popularCities[layout[2]];
                return Column(
                  children: [
                    _FeaturedDestinationCard(
                      data: featured,
                      onTap: () => widget.onOpenCity(featured.name),
                    ),
                    SizedBox(height: compact ? 7 : 12),
                    Row(
                      children: [
                        Expanded(
                          child: _SmallDestinationCard(
                            data: firstSmall,
                            onTap: () => widget.onOpenCity(firstSmall.name),
                          ),
                        ),
                        SizedBox(width: compact ? 7 : 12),
                        Expanded(
                          child: _SmallDestinationCard(
                            data: secondSmall,
                            onTap: () => widget.onOpenCity(secondSmall.name),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: compact ? 9 : 18),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                _pageLayouts.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: _CarouselDot(active: index == _activePage),
                ),
              ),
            ),
          ),
          SizedBox(height: compact ? 12 : 25),
          Text(
            'Другие города',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: compact ? 15 : 21,
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: compact ? 8 : 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.otherCities.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: compact ? 7 : 12,
              mainAxisSpacing: compact ? 7 : 12,
              mainAxisExtent: compact ? 62 : 82,
            ),
            itemBuilder: (_, index) => _OtherCityTile(
              data: widget.otherCities[index],
              onTap: () => widget.onOpenCity(widget.otherCities[index].name),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedDestinationCard extends StatelessWidget {
  const _FeaturedDestinationCard({required this.data, required this.onTap});
  final _CityCardData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          height: compact ? 180 : 248,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: AppColors.border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _approvedDestinationPhoto(data.name, data.asset)),
                Container(
                  height: compact ? 40 : 56,
                  padding: EdgeInsets.fromLTRB(compact ? 10 : 17, compact ? 2 : 4, compact ? 10 : 17, compact ? 2 : 4),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: compact ? 13.8 : 21,
                          height: 1.0,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: compact ? 1 : 3),
                      Text(
                        data.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: AppColors.muted, fontSize: compact ? 8.9 : 13.5, height: 1.0),
                      ),
                    ],
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

class _SmallDestinationCard extends StatelessWidget {
  const _SmallDestinationCard({required this.data, required this.onTap});
  final _CityCardData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: compact ? 116 : 166,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _approvedDestinationPhoto(data.name, data.asset)),
                Container(
                  height: compact ? 35 : 44,
                  padding: EdgeInsets.fromLTRB(compact ? 7 : 12, 4, 6, 4),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: compact ? 10.8 : 15.5,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: compact ? 7.8 : 10.5, color: AppColors.muted),
                      ),
                    ],
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

class _OtherCityTile extends StatelessWidget {
  const _OtherCityTile({required this.data, required this.onTap});
  final _SmallCityData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrowTile = constraints.maxWidth < 160;
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: narrowTile ? 7 : 12,
                vertical: narrowTile ? 5 : 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: narrowTile ? 34 : 48,
                    height: narrowTile ? 34 : 48,
                    decoration: BoxDecoration(
                      color: data.iconBackground,
                      borderRadius: BorderRadius.circular(narrowTile ? 11 : 14),
                    ),
                    child: Icon(
                      Icons.account_balance_rounded,
                      color: data.iconColor,
                      size: narrowTile ? 19 : 25,
                    ),
                  ),
                  SizedBox(width: narrowTile ? 7 : 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              data.name,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: narrowTile ? 10.8 : 13.5,
                                color: AppColors.navy,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: narrowTile ? 2 : 4),
                        SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${cityHotelCounts[data.name] ?? 0} гостиниц',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: narrowTile ? 9.2 : 11.5,
                                color: AppColors.muted,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.navy,
                    size: narrowTile ? 19 : 24,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CarouselDot extends StatelessWidget {
  const _CarouselDot({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: active ? 6 : 4,
      height: active ? 6 : 4,
      decoration: BoxDecoration(
        color: active ? AppColors.gold : const Color(0xFFDDE1EA),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CityCardData {
  const _CityCardData(this.name, this.subtitle, this.asset);
  final String name;
  final String subtitle;
  final String asset;
}

class _SmallCityData {
  const _SmallCityData(this.name, this.iconBackground, this.iconColor);
  final String name;
  final Color iconBackground;
  final Color iconColor;
}
