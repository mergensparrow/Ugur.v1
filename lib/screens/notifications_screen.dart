import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool onlyNew = false;

  static const items = <_NotificationItem>[
    _NotificationItem(
      icon: Icons.check_rounded,
      color: AppColors.success,
      background: Color(0xFFECFAF0),
      title: 'Номер подтверждён',
      subtitle: 'Yyldyz Hotel · 2 гостя · Стандарт',
      time: '1 мин',
      initiallyNew: true,
      group: 'Сегодня',
    ),
    _NotificationItem(
      icon: Icons.schedule_rounded,
      color: AppColors.warning,
      background: Color(0xFFFFF5E4),
      title: 'Оператор проверяет',
      subtitle: 'Mary Hotel · уточняем наличие',
      time: '12 мин',
      initiallyNew: true,
      group: 'Сегодня',
    ),
    _NotificationItem(
      icon: Icons.send_rounded,
      color: AppColors.navy,
      background: Color(0xFFEDF4FF),
      title: 'Запрос отправлен',
      subtitle: 'Yyldyz Hotel передан оператору',
      time: '01:42',
      initiallyNew: false,
      group: 'Сегодня',
    ),
    _NotificationItem(
      icon: Icons.remove_rounded,
      color: AppColors.danger,
      background: Color(0xFFFFECEE),
      title: 'Свободных номеров нет',
      subtitle: 'Ak Altyn Hotel',
      time: 'Вчера',
      initiallyNew: false,
      group: 'Ранее',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    final veryCompact = context.isVeryCompactLayout;
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (_, __) {
        final cleared = AppState.instance.notificationsCleared;
        final unread = AppState.instance.unreadNotifications;
        final available = cleared ? const <_NotificationItem>[] : items;
        final visible = onlyNew
            ? available.where((item) => item.initiallyNew && unread > 0).toList()
            : available;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: widget.showBackButton
              ? AppBar(
                  title: const Text('Уведомления', style: TextStyle(fontWeight: FontWeight.w800)),
                )
              : null,
          body: SafeArea(
            top: !widget.showBackButton,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                compact ? 16 : 18,
                widget.showBackButton ? (compact ? 18 : 22) : (compact ? 42 : 52),
                compact ? 16 : 18,
                22,
              ),
              children: [
                if (!widget.showBackButton)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: compact ? 36 : 44,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Уведомления',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: compact ? 31 : 39,
                                    height: 1,
                                    letterSpacing: -1,
                                    color: AppColors.navy,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: compact ? 8 : 12),
                            Text(
                              '$unread новых',
                              style: TextStyle(fontSize: compact ? 14.5 : 18, color: AppColors.muted),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: available.isEmpty ? null : () => AppState.instance.markNotificationsRead(),
                        icon: Icon(Icons.done_all_rounded, size: compact ? 17 : 20),
                        label: Text(
                          veryCompact ? 'Прочитать' : 'Прочитать все',
                          style: TextStyle(fontSize: compact ? 11.5 : 14),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          minimumSize: Size(veryCompact ? 100 : (compact ? 114 : 142), compact ? 42 : 50),
                          padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
                        ),
                      ),
                    ],
                  )
                else
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: available.isEmpty ? null : () => AppState.instance.markNotificationsRead(),
                      icon: const Icon(Icons.done_all_rounded, size: 20),
                      label: const Text('Прочитать все'),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border)),
                    ),
                  ),
                SizedBox(height: compact ? 18 : 27),
                _NotificationTabs(
                  onlyNew: onlyNew,
                  unread: unread,
                  onChanged: (value) => setState(() => onlyNew = value),
                ),
                SizedBox(height: compact ? 20 : 31),
                if (visible.isEmpty)
                  const _EmptyNotifications()
                else ...[
                  for (final group in const ['Сегодня', 'Ранее']) ...[
                    if (visible.any((item) => item.group == group)) ...[
                      Text(
                        group,
                        style: TextStyle(fontSize: compact ? 13 : 15, color: AppColors.muted),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            for (final item in visible.where((item) => item.group == group)) ...[
                              _NotificationRow(item: item, unread: unread),
                              if (item != visible.where((candidate) => candidate.group == group).last)
                                Divider(height: 1, indent: compact ? 62 : 78),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 21),
                    ],
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NotificationTabs extends StatelessWidget {
  const _NotificationTabs({required this.onlyNew, required this.unread, required this.onChanged});
  final bool onlyNew;
  final int unread;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return Container(
      height: compact ? 40 : 57,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(label: 'Все', selected: !onlyNew, onTap: () => onChanged(false)),
          ),
          Expanded(
            child: _TabButton(label: 'Новые $unread', selected: onlyNew, onTap: () => onChanged(true)),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 210),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.navy,
            fontSize: context.isCompactLayout ? 13.2 : 15,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.item, required this.unread});
  final _NotificationItem item;
  final int unread;

  @override
  Widget build(BuildContext context) {
    final isNew = item.initiallyNew && unread > 0;
    final compact = context.isCompactLayout;
    return InkWell(
      onTap: () => AppState.instance.markNotificationsRead(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          compact ? 10 : 13,
          compact ? 11 : 16,
          compact ? 9 : 10,
          compact ? 11 : 16,
        ),
        child: Row(
          children: [
            Container(
              width: compact ? 40 : 51,
              height: compact ? 40 : 51,
              decoration: BoxDecoration(color: item.background, borderRadius: BorderRadius.circular(16)),
              child: Icon(item.icon, color: item.color, size: compact ? 22 : 29),
            ),
            SizedBox(width: compact ? 10 : 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: compact ? 12.5 : 15.5,
                      color: AppColors.navy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: compact ? 10.4 : 12.5, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            SizedBox(width: compact ? 4 : 7),
            Text(item.time, style: TextStyle(fontSize: compact ? 9.8 : 11.5, color: AppColors.muted)),
            if (isNew) ...[
              SizedBox(width: compact ? 4 : 8),
              Container(
                width: compact ? 6 : 9,
                height: compact ? 6 : 9,
                decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
              ),
            ],
            SizedBox(width: compact ? 4 : 8),
            Icon(Icons.chevron_right_rounded, color: AppColors.navy, size: compact ? 21 : 24),
          ],
        ),
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 80, bottom: 120),
      child: Column(
        children: [
          Icon(Icons.notifications_none_rounded, size: 62, color: AppColors.muted),
          SizedBox(height: 16),
          Text('Уведомлений пока нет', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _NotificationItem {
  const _NotificationItem({
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.initiallyNew,
    required this.group,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String title;
  final String subtitle;
  final String time;
  final bool initiallyNew;
  final String group;
}
