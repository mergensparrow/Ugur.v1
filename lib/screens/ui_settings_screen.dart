import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/app_state.dart';
import '../theme/app_theme.dart';

Future<void> showUiDesignerSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => DraggableScrollableSheet(
      initialChildSize: .78,
      minChildSize: .42,
      maxChildSize: .96,
      expand: false,
      builder: (_, controller) => Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        clipBehavior: Clip.antiAlias,
        child: _UiDesignerBody(
          controller: controller,
          showCloseButton: true,
          onClose: () => Navigator.pop(sheetContext),
        ),
      ),
    ),
  );
}

class UiSettingsScreen extends StatelessWidget {
  const UiSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Режим дизайнера',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: const _UiDesignerBody(),
    );
  }
}

class _UiDesignerBody extends StatelessWidget {
  const _UiDesignerBody({
    this.controller,
    this.showCloseButton = false,
    this.onClose,
  });

  final ScrollController? controller;
  final bool showCloseButton;
  final VoidCallback? onClose;

  String _percent(double value) => '${(value * 100).round()}%';
  String _pixels(double value) => '${value.round()} px';

  Future<void> _copySettings(BuildContext context) async {
    final json = const JsonEncoder.withIndent('  ').convert(
      AppState.instance.uiTuningSnapshot,
    );
    await Clipboard.setData(ClipboardData(text: json));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Настройки скопированы в буфер обмена')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (_, __) {
        final state = AppState.instance;
        return ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 32),
          children: [
            if (showCloseButton) ...[
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9DFEA),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: onClose,
                    tooltip: 'Закрыть',
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const Text(
                'Режим дизайнера',
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
            ],
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F8FE),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'Изменения применяются сразу и сохраняются на этом устройстве. '
                'Пять раз нажмите на логотип Ugur на главной странице, чтобы открыть эту панель.',
                style: TextStyle(color: AppColors.muted, height: 1.42),
              ),
            ),
            const SizedBox(height: 20),
            const _SectionTitle('Весь интерфейс'),
            const SizedBox(height: 10),
            _TuningSlider(
              title: 'Размер элементов',
              subtitle: 'Общий масштаб карточек, кнопок и отступов',
              valueLabel: _percent(state.uiScale),
              value: state.uiScale,
              min: .82,
              max: 1.18,
              divisions: 36,
              step: .01,
              onChanged: state.setUiScale,
            ),
            const SizedBox(height: 12),
            _TuningSlider(
              title: 'Размер текста',
              subtitle: 'Шрифты без изменения геометрии блоков',
              valueLabel: _percent(state.fontScale),
              value: state.fontScale,
              min: .82,
              max: 1.20,
              divisions: 38,
              step: .01,
              onChanged: state.setFontScale,
            ),
            const SizedBox(height: 12),
            _TuningSlider(
              title: 'Нижнее меню',
              subtitle: 'Высота панели, иконки и подписи',
              valueLabel: _percent(state.bottomNavScale),
              value: state.bottomNavScale,
              min: .82,
              max: 1.18,
              divisions: 36,
              step: .01,
              onChanged: state.setBottomNavScale,
            ),
            const SizedBox(height: 22),
            const _SectionTitle('Главный экран'),
            const SizedBox(height: 10),
            _TuningSlider(
              title: 'Отступ перед голубым блоком',
              subtitle: 'Расстояние между логотипом и верхней карточкой',
              valueLabel: _percent(state.homePanelGapScale),
              value: state.homePanelGapScale,
              min: .50,
              max: 1.80,
              divisions: 26,
              step: .05,
              onChanged: state.setHomePanelGapScale,
            ),
            const SizedBox(height: 12),
            _TuningSlider(
              title: 'Содержимое голубого блока',
              subtitle: 'Сдвигает весь контент блока вверх или вниз',
              valueLabel: _pixels(state.homeContentOffset),
              value: state.homeContentOffset,
              min: -30,
              max: 80,
              divisions: 55,
              step: 2,
              onChanged: state.setHomeContentOffset,
            ),
            const SizedBox(height: 12),
            _TuningSlider(
              title: 'Карточки популярных мест',
              subtitle: 'Высота фотографий и подписей в карусели',
              valueLabel: _percent(state.homeCardsScale),
              value: state.homeCardsScale,
              min: .82,
              max: 1.18,
              divisions: 36,
              step: .01,
              onChanged: state.setHomeCardsScale,
            ),
            const SizedBox(height: 12),
            _TuningSlider(
              title: 'Низ голубого блока',
              subtitle: 'Свободное место после кнопки «Найти гостиницы»',
              valueLabel: _pixels(state.homePanelBottomSpace),
              value: state.homePanelBottomSpace,
              min: -18,
              max: 120,
              divisions: 69,
              step: 2,
              onChanged: state.setHomePanelBottomSpace,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: state.resetUiTuning,
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: const Text('Сбросить'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _copySettings(context),
                    icon: const Icon(Icons.copy_rounded),
                    label: const Text('Копировать JSON'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.navy,
        fontSize: 19,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _TuningSlider extends StatelessWidget {
  const _TuningSlider({
    required this.title,
    required this.subtitle,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.step,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final double step;
  final ValueChanged<double> onChanged;

  void _adjust(double delta) {
    onChanged((value + delta).clamp(min, max).toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x0A031B4E), blurRadius: 14, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                    fontSize: 15.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4D7),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  valueLabel,
                  style: const TextStyle(
                    color: Color(0xFF9B7118),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.muted, fontSize: 12.5),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              _StepButton(
                icon: Icons.remove_rounded,
                onPressed: value <= min ? null : () => _adjust(-step),
              ),
              Expanded(
                child: Slider(
                  value: value.clamp(min, max).toDouble(),
                  min: min,
                  max: max,
                  divisions: divisions,
                  label: valueLabel,
                  onChanged: onChanged,
                ),
              ),
              _StepButton(
                icon: Icons.add_rounded,
                onPressed: value >= max ? null : () => _adjust(step),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, size: 20),
    );
  }
}
