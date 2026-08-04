import 'package:flutter/material.dart';
import 'data/app_state.dart';
import 'data/favorites_store.dart';
import 'theme/app_theme.dart';
import 'screens/main_shell.dart';
import 'screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.initialize();
  FavoritesStore.syncFromState();
  runApp(const UgurApp());
}

EdgeInsets _divideInsets(EdgeInsets value, double divisor) => EdgeInsets.fromLTRB(
  value.left / divisor,
  value.top / divisor,
  value.right / divisor,
  value.bottom / divisor,
);

class UgurApp extends StatelessWidget {
  const UgurApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (_, __) {
        final state = AppState.instance;
        return MaterialApp(
          title: 'Ugur',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          builder: (context, child) {
            final media = MediaQuery.of(context);
            final scale = state.uiScale;
            final logicalSize = Size(
              media.size.width / scale,
              media.size.height / scale,
            );
            final tunedMedia = media.copyWith(
              size: logicalSize,
              padding: _divideInsets(media.padding, scale),
              viewPadding: _divideInsets(media.viewPadding, scale),
              viewInsets: _divideInsets(media.viewInsets, scale),
              systemGestureInsets: _divideInsets(media.systemGestureInsets, scale),
              textScaler: TextScaler.linear(state.fontScale),
            );
            return ClipRect(
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: logicalSize.width,
                  height: logicalSize.height,
                  child: MediaQuery(
                    data: tunedMedia,
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              ),
            );
          },
          home: state.isAuthenticated
              ? const MainShell()
              : const WelcomeScreen(),
        );
      },
    );
  }
}
