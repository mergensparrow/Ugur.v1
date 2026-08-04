import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'edit_profile_screen.dart';
import 'welcome_screen.dart';

class PersonalProfileScreen extends StatelessWidget {
  const PersonalProfileScreen({super.key});

  Future<void> _edit(BuildContext context) async {
    final updated = await Navigator.of(context).push<ProfileData>(
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(initialData: AppState.instance.profile),
      ),
    );
    if (updated != null && context.mounted) {
      await AppState.instance.updateProfile(updated);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Данные профиля обновлены.')),
      );
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить аккаунт?'),
        content: const Text(
          'Будут удалены локальные данные профиля. Это действие нельзя отменить.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await AppState.instance.deleteAccount();
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (_, __) {
        final data = AppState.instance.profile;

        Widget row(String label, String value) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                subtitle: Text(
                  value.isEmpty ? 'Не указано' : value,
                  style: const TextStyle(color: AppColors.text, fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            );

        return Scaffold(
          appBar: AppBar(title: const Text('Личный профиль', style: TextStyle(fontWeight: FontWeight.w900))),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: AppColors.navy,
                  child: Icon(Icons.person, color: Colors.white, size: 54),
                ),
              ),
              const SizedBox(height: 24),
              row('Имя', data.name),
              row('Телефон', data.phone),
              row('Email', data.email),
              row('Любимые города', data.favoriteCities),
              row('Предпочитаемая цена', data.preferredPrice),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => _edit(context),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Изменить данные'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => _deleteAccount(context),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Удалить аккаунт'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
              ),
            ],
          ),
        );
      },
    );
  }
}
