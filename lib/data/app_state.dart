import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

enum AuthMode { none, guest, registered }

class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  static const _authKey = 'auth_mode';
  static const _nameKey = 'profile_name';
  static const _phoneKey = 'profile_phone';
  static const _emailKey = 'profile_email';
  static const _citiesKey = 'profile_cities';
  static const _priceKey = 'profile_price';
  static const _unreadKey = 'notification_unread';
  static const _clearedKey = 'notifications_cleared';
  static const _favoritesKey = 'favorite_hotels';
  static const _uiScaleKey = 'ui_scale';
  static const _fontScaleKey = 'font_scale';
  static const _bottomNavScaleKey = 'bottom_nav_scale';
  static const _homePanelGapScaleKey = 'home_panel_gap_scale';
  static const _homeContentOffsetKey = 'home_content_offset';
  static const _homeCardsScaleKey = 'home_cards_scale';
  static const _homePanelBottomSpaceKey = 'home_panel_bottom_space';

  late SharedPreferences _prefs;

  AuthMode authMode = AuthMode.none;
  ProfileData profile = const ProfileData(
    name: '',
    phone: '',
    email: '',
    favoriteCities: '',
    preferredPrice: '',
  );
  int unreadNotifications = 2;
  bool notificationsCleared = false;
  double uiScale = 1.0;
  double fontScale = 1.0;
  double bottomNavScale = 1.0;
  double homePanelGapScale = 1.0;
  double homeContentOffset = 0.0;
  double homeCardsScale = 1.0;
  double homePanelBottomSpace = 0.0;

  Set<String> favoriteHotels = <String>{
    'Avaza Grand Hotel',
    'Mary Hotel',
    'Dashoguz Hotel',
  };

  bool get isAuthenticated => authMode != AuthMode.none;
  bool get isGuest => authMode == AuthMode.guest;
  bool get isRegistered => authMode == AuthMode.registered;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    authMode = switch (_prefs.getString(_authKey)) {
      'guest' => AuthMode.guest,
      'registered' => AuthMode.registered,
      _ => AuthMode.none,
    };
    profile = ProfileData(
      name: _prefs.getString(_nameKey) ?? '',
      phone: _prefs.getString(_phoneKey) ?? '',
      email: _prefs.getString(_emailKey) ?? '',
      favoriteCities: _prefs.getString(_citiesKey) ?? '',
      preferredPrice: _prefs.getString(_priceKey) ?? '',
    );
    unreadNotifications = _prefs.getInt(_unreadKey) ?? 2;
    notificationsCleared = _prefs.getBool(_clearedKey) ?? false;
    favoriteHotels = (_prefs.getStringList(_favoritesKey) ?? favoriteHotels.toList()).toSet();
    uiScale = (_prefs.getDouble(_uiScaleKey) ?? 1.0).clamp(0.82, 1.18).toDouble();
    fontScale = (_prefs.getDouble(_fontScaleKey) ?? 1.0).clamp(0.82, 1.20).toDouble();
    bottomNavScale = (_prefs.getDouble(_bottomNavScaleKey) ?? 1.0).clamp(0.82, 1.18).toDouble();
    homePanelGapScale = (_prefs.getDouble(_homePanelGapScaleKey) ?? 1.0).clamp(0.50, 1.80).toDouble();
    homeContentOffset = (_prefs.getDouble(_homeContentOffsetKey) ?? 0.0).clamp(-30.0, 80.0).toDouble();
    homeCardsScale = (_prefs.getDouble(_homeCardsScaleKey) ?? 1.0).clamp(0.82, 1.18).toDouble();
    homePanelBottomSpace = (_prefs.getDouble(_homePanelBottomSpaceKey) ?? 0.0).clamp(-18.0, 120.0).toDouble();
  }

  Future<void> continueAsGuest() async {
    authMode = AuthMode.guest;
    profile = const ProfileData(
      name: 'Гость',
      phone: '',
      email: '',
      favoriteCities: '',
      preferredPrice: '',
    );
    await _prefs.setString(_authKey, 'guest');
    notifyListeners();
  }

  Future<void> signIn({required String identifier}) async {
    authMode = AuthMode.registered;
    final existingName = _prefs.getString(_nameKey);
    profile = ProfileData(
      name: (existingName != null && existingName.trim().isNotEmpty)
          ? existingName
          : identifier.split('@').first,
      phone: _prefs.getString(_phoneKey) ?? (identifier.contains('@') ? '' : identifier),
      email: _prefs.getString(_emailKey) ?? (identifier.contains('@') ? identifier : ''),
      favoriteCities: _prefs.getString(_citiesKey) ?? '',
      preferredPrice: _prefs.getString(_priceKey) ?? '',
    );
    await _saveProfile();
    await _prefs.setString(_authKey, 'registered');
    notifyListeners();
  }

  Future<void> register(ProfileData value) async {
    authMode = AuthMode.registered;
    profile = value;
    await _prefs.setString(_authKey, 'registered');
    await _saveProfile();
    notifyListeners();
  }

  Future<void> updateProfile(ProfileData value) async {
    profile = value;
    await _saveProfile();
    notifyListeners();
  }

  Future<void> logout() async {
    authMode = AuthMode.none;
    await _prefs.remove(_authKey);
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    authMode = AuthMode.none;
    profile = const ProfileData(
      name: '',
      phone: '',
      email: '',
      favoriteCities: '',
      preferredPrice: '',
    );
    for (final key in [_authKey, _nameKey, _phoneKey, _emailKey, _citiesKey, _priceKey]) {
      await _prefs.remove(key);
    }
    notifyListeners();
  }

  Future<void> markNotificationsRead() async {
    if (unreadNotifications == 0) return;
    unreadNotifications = 0;
    await _prefs.setInt(_unreadKey, 0);
    notifyListeners();
  }

  Future<void> clearNotifications() async {
    notificationsCleared = true;
    unreadNotifications = 0;
    await _prefs.setBool(_clearedKey, true);
    await _prefs.setInt(_unreadKey, 0);
    notifyListeners();
  }

  bool isFavorite(String hotelName) => favoriteHotels.contains(hotelName);

  Future<void> toggleFavorite(String hotelName) async {
    final next = Set<String>.from(favoriteHotels);
    if (!next.add(hotelName)) next.remove(hotelName);
    favoriteHotels = next;
    await _prefs.setStringList(_favoritesKey, favoriteHotels.toList()..sort());
    notifyListeners();
  }


  void setUiScale(double value) {
    uiScale = value.clamp(0.82, 1.18).toDouble();
    _prefs.setDouble(_uiScaleKey, uiScale);
    notifyListeners();
  }

  void setFontScale(double value) {
    fontScale = value.clamp(0.82, 1.20).toDouble();
    _prefs.setDouble(_fontScaleKey, fontScale);
    notifyListeners();
  }

  void setBottomNavScale(double value) {
    bottomNavScale = value.clamp(0.82, 1.18).toDouble();
    _prefs.setDouble(_bottomNavScaleKey, bottomNavScale);
    notifyListeners();
  }

  void setHomePanelGapScale(double value) {
    homePanelGapScale = value.clamp(0.50, 1.80).toDouble();
    _prefs.setDouble(_homePanelGapScaleKey, homePanelGapScale);
    notifyListeners();
  }

  void setHomeContentOffset(double value) {
    homeContentOffset = value.clamp(-30.0, 80.0).toDouble();
    _prefs.setDouble(_homeContentOffsetKey, homeContentOffset);
    notifyListeners();
  }

  void setHomeCardsScale(double value) {
    homeCardsScale = value.clamp(0.82, 1.18).toDouble();
    _prefs.setDouble(_homeCardsScaleKey, homeCardsScale);
    notifyListeners();
  }

  void setHomePanelBottomSpace(double value) {
    homePanelBottomSpace = value.clamp(-18.0, 120.0).toDouble();
    _prefs.setDouble(_homePanelBottomSpaceKey, homePanelBottomSpace);
    notifyListeners();
  }

  Map<String, Object> get uiTuningSnapshot => <String, Object>{
        'uiScale': double.parse(uiScale.toStringAsFixed(2)),
        'fontScale': double.parse(fontScale.toStringAsFixed(2)),
        'bottomNavScale': double.parse(bottomNavScale.toStringAsFixed(2)),
        'homePanelGapScale': double.parse(homePanelGapScale.toStringAsFixed(2)),
        'homeContentOffset': double.parse(homeContentOffset.toStringAsFixed(1)),
        'homeCardsScale': double.parse(homeCardsScale.toStringAsFixed(2)),
        'homePanelBottomSpace': double.parse(homePanelBottomSpace.toStringAsFixed(1)),
      };

  void resetUiTuning() {
    uiScale = 1.0;
    fontScale = 1.0;
    bottomNavScale = 1.0;
    homePanelGapScale = 1.0;
    homeContentOffset = 0.0;
    homeCardsScale = 1.0;
    homePanelBottomSpace = 0.0;
    _prefs.setDouble(_uiScaleKey, uiScale);
    _prefs.setDouble(_fontScaleKey, fontScale);
    _prefs.setDouble(_bottomNavScaleKey, bottomNavScale);
    _prefs.setDouble(_homePanelGapScaleKey, homePanelGapScale);
    _prefs.setDouble(_homeContentOffsetKey, homeContentOffset);
    _prefs.setDouble(_homeCardsScaleKey, homeCardsScale);
    _prefs.setDouble(_homePanelBottomSpaceKey, homePanelBottomSpace);
    notifyListeners();
  }

  Future<void> _saveProfile() async {
    await _prefs.setString(_nameKey, profile.name);
    await _prefs.setString(_phoneKey, profile.phone);
    await _prefs.setString(_emailKey, profile.email);
    await _prefs.setString(_citiesKey, profile.favoriteCities);
    await _prefs.setString(_priceKey, profile.preferredPrice);
  }
}
