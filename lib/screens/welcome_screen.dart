import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'main_shell.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _open(BuildContext context) async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Закрыть',
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 520),
      pageBuilder: (_, __, ___) => const Material(
        color: Colors.transparent,
        child: Align(alignment: Alignment.bottomCenter, child: _LoginSheet()),
      ),
      transitionBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/welcome_bg.jpg', fit: BoxFit.cover, filterQuality: FilterQuality.high),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xAA061626), Color(0x18000000), Color(0xEF071A2B)],
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 700;
                return Padding(
                  padding: EdgeInsets.fromLTRB(24, compact ? 18 : 28, 24, compact ? 16 : 26),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.route_rounded, color: AppColors.gold, size: 41),
                          SizedBox(width: 9),
                          Text('ugur', style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900)),
                        ],
                      ),
                      const Spacer(flex: 5),
                      Text(
                        'Путешествие\nначинается здесь',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: compact ? 34 : 40, height: 1.03, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: compact ? 12 : 18),
                      Text(
                        'Все гостиницы Туркменистана\nв одном приложении',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: compact ? 15 : 17, height: 1.35),
                      ),
                      const Spacer(flex: 2),
                      FilledButton(
                        onPressed: () => _open(context),
                        style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.navy),
                        child: const Text('Начать'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginSheet extends StatelessWidget {
  const _LoginSheet();

  Future<void> _guest(BuildContext context) async {
    final navigator = Navigator.of(context);
    await AppState.instance.continueAsGuest();
    if (!context.mounted) return;
    navigator.pushAndRemoveUntil(
      PageRouteBuilder<void>(
        pageBuilder: (_, animation, __) => FadeTransition(opacity: animation, child: const MainShell()),
        transitionDuration: const Duration(milliseconds: 380),
      ),
      (_) => false,
    );
  }

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String title, String subtitle, VoidCallback onTap) => ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      leading: CircleAvatar(backgroundColor: const Color(0xFFF1F3F6), child: Icon(icon, color: AppColors.navy)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
    );

    return Container(
      padding: EdgeInsets.fromLTRB(18, 12, 18, 20 + MediaQuery.paddingOf(context).bottom),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 44, height: 5, decoration: BoxDecoration(color: const Color(0xFFD5D7DB), borderRadius: BorderRadius.circular(99))),
          const SizedBox(height: 12),
          item(Icons.login_rounded, 'Войти', 'У меня есть аккаунт', () => _openScreen(context, const LoginScreen())),
          item(Icons.person_add_alt_1_rounded, 'Создать аккаунт', 'Новый пользователь', () => _openScreen(context, const RegisterScreen())),
          item(Icons.visibility_outlined, 'Продолжить как гость', 'Без регистрации', () => _guest(context)),
          const SizedBox(height: 10),
          const Text(
            'Продолжая, вы соглашаетесь с условиями использования и политикой конфиденциальности.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 11, height: 1.4),
          ),
        ],
      ),
    );
  }
}
