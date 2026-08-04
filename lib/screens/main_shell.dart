import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../widgets/ugur_bottom_nav.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'requests_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int index;

  final pages = const [
    HomeScreen(),
    FavoritesScreen(),
    RequestsScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex.clamp(0, pages.length - 1).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (_, __) {
        final unread = AppState.instance.unreadNotifications;
        return Scaffold(
          backgroundColor: Colors.white,
          body: IndexedStack(index: index, children: pages),
          bottomNavigationBar: SafeArea(
            top: false,
            child: UgurBottomNav(
              selectedIndex: index,
              unreadCount: unread,
              onSelected: (value) {
                setState(() => index = value);
              },
            ),
          ),
        );
      },
    );
  }
}
