import 'package:flutter/foundation.dart';
import 'app_state.dart';

class FavoritesStore {
  FavoritesStore._();

  static final ValueNotifier<Set<String>> hotels =
      ValueNotifier<Set<String>>(Set<String>.from(AppState.instance.favoriteHotels));

  static void syncFromState() {
    hotels.value = Set<String>.from(AppState.instance.favoriteHotels);
  }

  static bool contains(String hotelName) => hotels.value.contains(hotelName);

  static Future<void> toggle(String hotelName) async {
    await AppState.instance.toggleFavorite(hotelName);
    syncFromState();
  }
}
