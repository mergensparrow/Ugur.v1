import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/mockup_image_slice.dart';
import 'hotel_detail_screen.dart';

Widget _approvedRequestPhoto(Hotel hotel) {
  final rect = switch (hotel.name) {
    'Yyldyz Hotel' => const Rect.fromLTWH(54, 510, 272, 285),
    'Sport Hotel' => const Rect.fromLTWH(54, 1117, 209, 194),
    'Ak Altyn Hotel' => const Rect.fromLTWH(54, 1360, 209, 195),
    _ => null,
  };
  if (rect == null) return Image.asset(hotel.image, fit: BoxFit.cover);
  return MockupImageSlice(
    asset: 'assets/images/mockup_requests.jpeg',
    sourceSize: const Size(853, 1844),
    sourceRect: rect,
  );
}

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  int selectedTab = 0;

  Hotel _hotel(String name) => hotels.firstWhere((hotel) => hotel.name == name);

  void _openHotel(Hotel hotel) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => HotelDetailScreen(hotel: hotel)));
  }

  void _showHelp() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Как работают запросы'),
        content: const Text(
          'После отправки оператор Ugur связывается с гостиницей и обновляет статус. '
          'Когда ответ будет готов, приложение покажет уведомление.',
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Понятно'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    final active = _hotel('Yyldyz Hotel');
    final completed = [_hotel('Sport Hotel'), _hotel('Ak Altyn Hotel')];
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          compact ? 10 : 14,
          16,
          compact ? 92 : 118,
        ),
        children: [
          _RequestsHeader(onHelp: _showHelp),
          SizedBox(height: compact ? 12 : 20),
          _RequestTabs(
            selectedIndex: selectedTab,
            onSelected: (value) => setState(() => selectedTab = value),
          ),
          SizedBox(height: compact ? 12 : 22),
          if (selectedTab != 2)
            _ActiveRequestCard(hotel: active),
          if (selectedTab == 0) SizedBox(height: compact ? 14 : 22),
          if (selectedTab != 1) ...[
            Text(
              'Завершённые',
              style: TextStyle(
                fontSize: compact ? 20 : 24,
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 9),
            ...completed.map(
              (hotel) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _CompletedRequestCard(hotel: hotel, onOpen: () => _openHotel(hotel)),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F7FD),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.notifications_none_rounded, color: AppColors.navy),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Когда оператор ответит, мы отправим уведомление',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.muted, fontSize: 10.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestsHeader extends StatelessWidget {
  const _RequestsHeader({required this.onHelp});
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return SizedBox(
      height: compact ? 126 : 185,
      child: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: _RequestsHeaderPainter())),
          Positioned(
            left: 2,
            top: compact ? 47 : 72,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Запросы',
                  style: TextStyle(
                    fontSize: compact ? 30 : 45,
                    height: 1,
                    letterSpacing: -1,
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: compact ? 8 : 12),
                Text(
                  'Проверки наличия и ответы операторов',
                  style: TextStyle(color: AppColors.muted, fontSize: compact ? 13 : 16),
                ),
              ],
            ),
          ),
          Positioned(
            right: 3,
            top: compact ? 3 : 12,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: onHelp,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: compact ? 42 : 54,
                  height: compact ? 42 : 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    Icons.help_outline_rounded,
                    color: AppColors.navy,
                    size: compact ? 23 : 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestsHeaderPainter extends CustomPainter {
  const _RequestsHeaderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final faint = Paint()
      ..color = const Color(0x1F7FA1C7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8;
    for (var i = 0; i < 9; i++) {
      final x = size.width * (.60 + i * .047);
      final base = size.height * .37;
      final h = 14.0 + (i % 3) * 13;
      canvas.drawRect(Rect.fromLTWH(x, base - h, 13, h), faint);
      canvas.drawLine(Offset(x + 6.5, base - h), Offset(x + 6.5, base - h - 11), faint);
    }
    final gold = Paint()
      ..color = const Color(0xFFCB982B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final p = Path()
      ..moveTo(size.width * .42, size.height * .50)
      ..cubicTo(size.width * .60, size.height * .37, size.width * .67, size.height * .22, size.width * .78, size.height * .40)
      ..cubicTo(size.width * .87, size.height * .56, size.width * .92, size.height * .55, size.width * 1.02, size.height * .42);
    canvas.drawPath(p, gold);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * .82, size.height * .29, 47, 35),
        const Radius.circular(10),
      ),
      gold,
    );
    canvas.drawLine(
      Offset(size.width * .85, size.height * .39),
      Offset(size.width * .88, size.height * .43),
      gold,
    );
    canvas.drawLine(
      Offset(size.width * .88, size.height * .43),
      Offset(size.width * .94, size.height * .34),
      gold,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RequestTabs extends StatelessWidget {
  const _RequestTabs({required this.selectedIndex, required this.onSelected});
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const labels = ['Все 3', 'В работе 1', 'Завершено 2'];
    final compact = context.isCompactLayout;

    return Align(
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: compact ? .90 : .88,
        child: Container(
          height: compact ? 40 : 58,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: List.generate(labels.length, (index) {
              final selected = index == selectedIndex;
              return Expanded(
                child: InkWell(
                  onTap: () => onSelected(index),
                  borderRadius: BorderRadius.circular(15),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.navy : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: compact ? 4 : 10,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          labels[index],
                          maxLines: 1,
                          style: TextStyle(
                            color: selected ? Colors.white : AppColors.navy,
                            fontSize: compact ? 11.6 : 14,
                            fontWeight: selected
                                ? FontWeight.w800
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _ActiveRequestCard extends StatelessWidget {
  const _ActiveRequestCard({required this.hotel});
  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return Container(
      padding: EdgeInsets.all(compact ? 8 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x88D4A535)),
        boxShadow: const [BoxShadow(color: Color(0x10031B4E), blurRadius: 18, offset: Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(compact ? 14 : 18),
                child: SizedBox(
                  width: compact ? 96 : 130,
                  height: compact ? 102 : 146,
                  child: _approvedRequestPhoto(hotel),
                ),
              ),
              SizedBox(width: compact ? 9 : 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel.name,
                      maxLines: 2,
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: compact ? 17.2 : 25,
                        height: 1.02,
                        color: AppColors.navy,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: compact ? 3 : 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, color: AppColors.gold, size: compact ? 17 : 22),
                        const SizedBox(width: 5),
                        Text(
                          hotel.city,
                          style: TextStyle(color: AppColors.muted, fontSize: compact ? 10 : 14),
                        ),
                      ],
                    ),
                    SizedBox(height: compact ? 5 : 12),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: compact ? 6 : 11,
                        vertical: compact ? 4 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5DC),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.support_agent_rounded,
                            color: AppColors.warning,
                            size: compact ? 16 : 19,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Оператор проверяет',
                              style: TextStyle(
                                color: AppColors.warning,
                                fontSize: compact ? 9.8 : 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: compact ? 5 : 12),
                    const Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _InfoChip(icon: Icons.person_outline_rounded, text: '2 гостя'),
                        _InfoChip(icon: Icons.bed_outlined, text: 'Стандарт'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 12 : 22),
          const _RequestProgress(),
          SizedBox(height: compact ? 7 : 18),
          const Divider(height: 1),
          SizedBox(height: compact ? 6 : 14),
          Text(
            'Ожидаем ответ оператора',
            style: TextStyle(color: AppColors.muted, fontSize: compact ? 10 : 14),
          ),
          const SizedBox(height: 5),
          Text(
            'Отправлено сегодня, 09:12',
            style: TextStyle(color: AppColors.muted, fontSize: compact ? 10 : 13),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 10,
        vertical: compact ? 5 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.muted, size: compact ? 16 : 19),
          SizedBox(width: compact ? 4 : 6),
          Text(text, style: TextStyle(color: AppColors.muted, fontSize: compact ? 10.2 : 12.5)),
        ],
      ),
    );
  }
}

class _RequestProgress extends StatelessWidget {
  const _RequestProgress();

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return Column(
      children: [
        Row(
          children: [
            _ProgressNode(icon: Icons.check_rounded, state: 2, compact: compact),
            Expanded(child: Container(height: 2, color: AppColors.success)),
            _ProgressNode(icon: null, state: 1, compact: compact),
            Expanded(child: Container(height: 2, color: AppColors.border)),
            _ProgressNode(icon: null, state: 0, compact: compact),
          ],
        ),
        SizedBox(height: compact ? 5 : 9),
        Row(
          children: [
            Expanded(
              child: Text(
                'Отправлен',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: compact ? 10.2 : 12, color: AppColors.navy),
              ),
            ),
            Expanded(
              child: Text(
                'Проверка',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: compact ? 10.2 : 12, color: AppColors.navy),
              ),
            ),
            Expanded(
              child: Text(
                'Ответ',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: compact ? 10.2 : 12, color: AppColors.navy),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressNode extends StatelessWidget {
  const _ProgressNode({required this.icon, required this.state, required this.compact});
  final IconData? icon;
  final int state;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = state == 2 ? AppColors.success : (state == 1 ? AppColors.gold : AppColors.border);
    return Container(
      width: compact ? 30 : 38,
      height: compact ? 30 : 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: state == 1 ? 3 : 2),
      ),
      child: icon == null
          ? Container(
              width: compact ? 15 : 20,
              height: compact ? 15 : 20,
              decoration: BoxDecoration(
                color: state == 1 ? AppColors.gold : Colors.white,
                shape: BoxShape.circle,
              ),
            )
          : Icon(icon, color: color, size: compact ? 19 : 25),
    );
  }
}

class _CompletedRequestCard extends StatelessWidget {
  const _CompletedRequestCard({required this.hotel, required this.onOpen});
  final Hotel hotel;
  final VoidCallback onOpen;

  bool get available => hotel.name == 'Sport Hotel';

  @override
  Widget build(BuildContext context) {
    final color = available ? AppColors.success : AppColors.danger;
    final compact = context.isCompactLayout;
    return Container(
      padding: EdgeInsets.all(compact ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x0D031B4E), blurRadius: 14, offset: Offset(0, 6))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(compact ? 13 : 16),
            child: SizedBox(
              width: compact ? 76 : 102,
              height: compact ? 76 : 102,
              child: _approvedRequestPhoto(hotel),
            ),
          ),
          SizedBox(width: compact ? 9 : 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: compact ? 14.8 : 20,
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${hotel.city} · ${available ? '1 гость · Стандарт' : '2 гостя · Люкс'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.muted, fontSize: compact ? 9.8 : 12.5),
                ),
                SizedBox(height: compact ? 4 : 8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 5 : 9,
                    vertical: compact ? 3 : 6,
                  ),
                  decoration: BoxDecoration(color: color.withOpacity(.10), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Icon(
                        available ? Icons.check_circle_outline_rounded : Icons.remove_circle_outline_rounded,
                        color: color,
                        size: compact ? 16 : 19,
                      ),
                      SizedBox(width: compact ? 4 : 5),
                      Flexible(
                        child: Text(
                          available ? 'Номер есть' : 'Свободных номеров нет',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: color,
                            fontSize: compact ? 9.8 : 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: compact ? 4 : 7),
                Text(
                  available ? 'Ответ получен сегодня, 09:26' : 'Ответ получен вчера, 18:40',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.muted, fontSize: compact ? 9.1 : 11.5),
                ),
              ],
            ),
          ),
          if (available)
            OutlinedButton(
              onPressed: onOpen,
              style: OutlinedButton.styleFrom(
                minimumSize: Size(compact ? 66 : 82, compact ? 33 : 42),
                padding: EdgeInsets.symmetric(horizontal: compact ? 4 : 10),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  context.isVeryCompactLayout ? 'Открыть' : 'Открыть гостиницу',
                  style: TextStyle(fontSize: compact ? 8.9 : 11.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
