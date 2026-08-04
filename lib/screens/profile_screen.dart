import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../theme/app_theme.dart';
import 'language_screen.dart';
import 'login_screen.dart';
import 'notification_settings_screen.dart';
import 'personal_profile_screen.dart';
import 'privacy_screen.dart';
import 'register_screen.dart';
import 'support_screen.dart';
import 'ui_settings_screen.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _logout(BuildContext context) async {
    await AppState.instance.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (_, __) {
        final state = AppState.instance;
        final compact = context.isCompactLayout;
        final guest = state.isGuest;
        final profile = state.profile;
        final displayName = guest
            ? 'Гость'
            : (profile.name.trim().isEmpty ? 'Пользователь Ugur' : profile.name.trim());
        final initial = displayName.isEmpty ? 'U' : displayName[0].toUpperCase();

        return SafeArea(
          child: ListView(
            padding: EdgeInsets.fromLTRB(compact ? 16 : 18, compact ? 34 : 42, compact ? 16 : 18, 22),
            children: [
              Text(
                'Профиль',
                style: TextStyle(
                  fontSize: compact ? 35 : 45,
                  height: 1,
                  letterSpacing: -1,
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: compact ? 9 : 13),
              Text(
                'Личные данные и настройки',
                style: TextStyle(color: AppColors.muted, fontSize: compact ? 14.8 : 18),
              ),
              SizedBox(height: compact ? 20 : 28),
              _ProfileCard(
                name: displayName,
                phone: guest ? '' : profile.phone,
                email: guest ? '' : profile.email,
                initial: initial,
                guest: guest,
                onEdit: guest ? null : () => _push(context, const PersonalProfileScreen()),
              ),
              SizedBox(height: compact ? 20 : 31),
              Text(
                'Настройки',
                style: TextStyle(color: AppColors.muted, fontSize: compact ? 14.8 : 18),
              ),
              SizedBox(height: compact ? 9 : 12),
              _SettingsCard(
                children: [
                  if (!guest)
                    _SettingsTile(
                      icon: Icons.person_outline_rounded,
                      iconColor: const Color(0xFFB6851E),
                      iconBackground: const Color(0xFFFFF5E5),
                      title: 'Личные данные',
                      onTap: () => _push(context, const PersonalProfileScreen()),
                    ),
                  _SettingsTile(
                    icon: Icons.language_rounded,
                    iconColor: const Color(0xFF1C7ED6),
                    iconBackground: const Color(0xFFEAF5FF),
                    title: 'Язык',
                    value: 'Русский',
                    onTap: () => _push(context, const LanguageScreen()),
                  ),
                  _SettingsTile(
                    icon: Icons.notifications_none_rounded,
                    iconColor: const Color(0xFF3048D8),
                    iconBackground: const Color(0xFFF0EFFF),
                    title: 'Уведомления',
                    value: 'Включены',
                    onTap: () => _push(context, const NotificationSettingsScreen()),
                  ),
                  _SettingsTile(
                    icon: Icons.tune_rounded,
                    iconColor: const Color(0xFFB6851E),
                    iconBackground: const Color(0xFFFFF5E5),
                    title: 'Размер интерфейса',
                    value: '${(state.uiScale * 100).round()}%',
                    onTap: () => _push(context, const UiSettingsScreen()),
                  ),
                ],
              ),
              SizedBox(height: compact ? 18 : 28),
              Text('Помощь', style: TextStyle(color: AppColors.muted, fontSize: compact ? 14.8 : 18)),
              SizedBox(height: compact ? 9 : 12),
              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: Icons.support_agent_rounded,
                    iconColor: const Color(0xFFB6851E),
                    iconBackground: const Color(0xFFFFF5E5),
                    title: 'Поддержка',
                    onTap: () => _push(context, const SupportScreen()),
                  ),
                  _SettingsTile(
                    icon: Icons.shield_outlined,
                    iconColor: const Color(0xFF1875D1),
                    iconBackground: const Color(0xFFEAF5FF),
                    title: 'Конфиденциальность',
                    onTap: () => _push(context, const PrivacyScreen()),
                  ),
                ],
              ),
              SizedBox(height: compact ? 16 : 26),
              if (!guest)
                OutlinedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
                  label: Text(
                    'Выйти из аккаунта',
                    style: TextStyle(
                      color: AppColors.danger,
                      fontSize: compact ? 15 : 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(compact ? 44 : 62),
                    side: const BorderSide(color: Color(0x66E42D35)),
                  ),
                )
              else
                Column(
                  children: [
                    FilledButton.icon(
                      onPressed: () => _push(context, const LoginScreen()),
                      icon: const Icon(Icons.login_rounded),
                      label: const Text('Войти'),
                      style: FilledButton.styleFrom(
                        minimumSize: Size.fromHeight(compact ? 44 : 60),
                      ),
                    ),
                    SizedBox(height: compact ? 7 : 12),
                    OutlinedButton.icon(
                      onPressed: () => _push(context, const RegisterScreen()),
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                      label: const Text('Создать аккаунт'),
                      style: OutlinedButton.styleFrom(minimumSize: Size.fromHeight(compact ? 43 : 58)),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.name,
    required this.phone,
    required this.email,
    required this.initial,
    required this.guest,
    required this.onEdit,
  });

  final String name;
  final String phone;
  final String email;
  final String initial;
  final bool guest;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    final veryCompact = context.isVeryCompactLayout;
    return Container(
      padding: EdgeInsets.all(compact ? 12 : 19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x10031B4E), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 62 : 86,
            height: compact ? 62 : 86,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFD66B), Color(0xFFD79A24)],
              ),
            ),
            child: Text(
              initial,
              style: TextStyle(
                fontFamily: 'serif',
                color: AppColors.navy,
                fontSize: compact ? 30 : 42,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: compact ? 13 : 17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (!guest)
                      Container(
                        width: 18,
                        height: 18,
                        margin: const EdgeInsets.only(right: 7),
                        decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                        child: const Icon(Icons.check_rounded, size: 13, color: Colors.white),
                      ),
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: compact ? 17.2 : 23,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!guest && phone.isNotEmpty) ...[
                  SizedBox(height: compact ? 3 : 9),
                  Text(phone, style: TextStyle(fontSize: compact ? 11.6 : 15, color: AppColors.muted)),
                ],
                if (!guest && email.isNotEmpty) ...[
                  SizedBox(height: compact ? 3 : 7),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: compact ? 11.6 : 15, color: AppColors.muted),
                  ),
                ],
                if (guest) ...[
                  SizedBox(height: compact ? 3 : 8),
                  Text(
                    'Войдите, чтобы сохранить данные',
                    style: TextStyle(fontSize: compact ? 11.5 : 13, color: AppColors.muted),
                  ),
                ],
              ],
            ),
          ),
          if (onEdit != null)
            veryCompact
                ? IconButton(
                    onPressed: onEdit,
                    tooltip: 'Изменить',
                    icon: const Icon(Icons.edit_outlined, size: 21),
                    color: AppColors.navy,
                    visualDensity: VisualDensity.compact,
                  )
                : TextButton.icon(
                    onPressed: onEdit,
                    icon: Icon(Icons.edit_outlined, size: compact ? 18 : 22),
                    label: Text('Изменить', style: TextStyle(fontSize: compact ? 12 : 14)),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.navy,
                      padding: EdgeInsets.symmetric(horizontal: compact ? 3 : 8),
                    ),
                  ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x0C031B4E), blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Divider(height: 1, indent: compact ? 60 : 74, endIndent: compact ? 10 : 15),
          ],
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.onTap,
    this.value,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          compact ? 10 : 14,
          compact ? 8 : 13,
          compact ? 9 : 12,
          compact ? 8 : 13,
        ),
        child: Row(
          children: [
            Container(
              width: compact ? 37 : 48,
              height: compact ? 37 : 48,
              decoration: BoxDecoration(color: iconBackground, borderRadius: BorderRadius.circular(15)),
              child: Icon(icon, color: iconColor, size: compact ? 20 : 28),
            ),
            SizedBox(width: compact ? 11 : 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: compact ? 13.5 : 17,
                  color: AppColors.navy,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value != null) ...[
              Text(value!, style: TextStyle(fontSize: compact ? 12.8 : 15, color: AppColors.muted)),
              SizedBox(width: compact ? 2 : 6),
            ],
            Icon(Icons.chevron_right_rounded, color: AppColors.navy, size: compact ? 22 : 27),
          ],
        ),
      ),
    );
  }
}
