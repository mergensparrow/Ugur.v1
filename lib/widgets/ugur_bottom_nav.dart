import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../theme/app_theme.dart';

class UgurBottomNav extends StatelessWidget {
  const UgurBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.unreadCount,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final int unreadCount;

  static const _items = <_NavData>[
    _NavData(_NavGlyphType.home, 'Главная'),
    _NavData(_NavGlyphType.heart, 'Избранное'),
    _NavData(_NavGlyphType.request, 'Запросы'),
    _NavData(_NavGlyphType.bell, 'Уведомления'),
    _NavData(_NavGlyphType.profile, 'Профиль'),
  ];

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    final navScale = AppState.instance.bottomNavScale;
    double scaled(double value) => value * navScale;
    return Container(
      margin: EdgeInsets.fromLTRB(scaled(compact ? 8 : 12), scaled(4), scaled(compact ? 8 : 12), scaled(compact ? 5 : 10)),
      padding: EdgeInsets.fromLTRB(scaled(compact ? 4 : 7), scaled(compact ? 6 : 10), scaled(compact ? 4 : 7), scaled(compact ? 5 : 8)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(scaled(30)),
        border: Border.all(color: const Color(0x0D061A45)),
        boxShadow: const [
          BoxShadow(color: Color(0x17061A45), blurRadius: 26, offset: Offset(0, 10)),
        ],
      ),
      child: Row(
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final active = index == selectedIndex;
          return Expanded(
            child: Semantics(
              button: true,
              selected: active,
              label: item.label,
              child: InkWell(
                onTap: () => onSelected(index),
                borderRadius: BorderRadius.circular(scaled(18)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: scaled(compact ? 46 : 62),
                      height: scaled(compact ? 46 : 62),
                      decoration: BoxDecoration(
                        color: active ? AppColors.navy : const Color(0xFFF6F7FB),
                        borderRadius: BorderRadius.circular(scaled(compact ? 16 : 20)),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Center(
                            child: _NavGlyph(
                              type: item.type,
                              size: scaled(compact ? 26 : 35),
                              color: active ? AppColors.gold : AppColors.navy,
                            ),
                          ),
                          if (index == 3 && unreadCount > 0)
                            Positioned(
                              top: scaled(compact ? 2 : 4),
                              right: scaled(compact ? 2 : 4),
                              child: Container(
                                constraints: BoxConstraints(
                                  minWidth: scaled(compact ? 16 : 18),
                                  minHeight: scaled(compact ? 16 : 18),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: scaled(compact ? 4 : 5)),
                                decoration: const BoxDecoration(
                                  color: AppColors.danger,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$unreadCount',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: scaled(compact ? 8 : 9),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: scaled(compact ? 4 : 6)),
                    SizedBox(
                      width: double.infinity,
                      height: scaled(compact ? 13 : 15),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Text(
                          item.label,
                          maxLines: 1,
                          style: TextStyle(
                            color: AppColors.navy,
                            fontSize: scaled(compact ? 9.2 : 11.3),
                            fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: scaled(compact ? 2 : 4)),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: active ? scaled(compact ? 24 : 30) : 0,
                      height: scaled(compact ? 2.2 : 3),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavData {
  const _NavData(this.type, this.label);
  final _NavGlyphType type;
  final String label;
}

enum _NavGlyphType { home, heart, request, bell, profile }

class _NavGlyph extends StatelessWidget {
  const _NavGlyph({required this.type, required this.size, required this.color});

  final _NavGlyphType type;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _NavGlyphPainter(type: type, color: color),
    );
  }
}

class _NavGlyphPainter extends CustomPainter {
  const _NavGlyphPainter({required this.type, required this.color});

  final _NavGlyphType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 32;
    canvas.save();
    canvas.scale(scale, scale);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.05
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (type) {
      case _NavGlyphType.home:
        final home = Path()
          ..moveTo(4.5, 15)
          ..lineTo(16, 5.5)
          ..lineTo(27.5, 15)
          ..lineTo(27.5, 27)
          ..lineTo(20.5, 27)
          ..lineTo(20.5, 20)
          ..lineTo(11.5, 20)
          ..lineTo(11.5, 27)
          ..lineTo(4.5, 27)
          ..close();
        canvas.drawPath(home, paint);
        break;
      case _NavGlyphType.heart:
        final heart = Path()
          ..moveTo(16, 27.5)
          ..cubicTo(13.8, 25.5, 5, 19.8, 5, 11.8)
          ..cubicTo(5, 7.4, 8.1, 5, 11.6, 5)
          ..cubicTo(13.8, 5, 15.3, 6.2, 16, 7.8)
          ..cubicTo(16.7, 6.2, 18.2, 5, 20.4, 5)
          ..cubicTo(23.9, 5, 27, 7.4, 27, 11.8)
          ..cubicTo(27, 19.8, 18.2, 25.5, 16, 27.5);
        canvas.drawPath(heart, paint);
        break;
      case _NavGlyphType.request:
        canvas.drawRRect(
          RRect.fromRectAndRadius(const Rect.fromLTWH(7, 4, 18, 24), const Radius.circular(3.5)),
          paint,
        );
        canvas.drawLine(const Offset(11, 11), const Offset(21, 11), paint);
        canvas.drawLine(const Offset(11, 15.5), const Offset(18, 15.5), paint);
        canvas.drawCircle(const Offset(20.5, 22.5), 1.7, paint);
        break;
      case _NavGlyphType.bell:
        final bell = Path()
          ..moveTo(6, 24)
          ..lineTo(8.8, 20.5)
          ..lineTo(8.8, 13.7)
          ..cubicTo(8.8, 8.8, 11.7, 6, 16, 6)
          ..cubicTo(20.3, 6, 23.2, 8.8, 23.2, 13.7)
          ..lineTo(23.2, 20.5)
          ..lineTo(26, 24)
          ..close();
        canvas.drawPath(bell, paint);
        canvas.drawLine(const Offset(13.2, 27), const Offset(18.8, 27), paint);
        break;
      case _NavGlyphType.profile:
        canvas.drawCircle(const Offset(16, 9.5), 5, paint);
        final shoulders = Path()
          ..moveTo(5, 27)
          ..cubicTo(5.7, 20.5, 9.8, 17.5, 16, 17.5)
          ..cubicTo(22.2, 17.5, 26.3, 20.5, 27, 27);
        canvas.drawPath(shoulders, paint);
        break;
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NavGlyphPainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.color != color;
  }
}
