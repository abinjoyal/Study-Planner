import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/focus_settings_provider.dart';
import '../providers/focus_timer_provider.dart';

class FocusSettingsPage extends ConsumerStatefulWidget {
  const FocusSettingsPage({super.key});

  @override
  ConsumerState<FocusSettingsPage> createState() => _FocusSettingsPageState();
}

class _FocusSettingsPageState extends ConsumerState<FocusSettingsPage> {
  late int _focusMins;
  late int _shortBreakMins;
  late int _longBreakMins;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(focusSettingsNotifierProvider);
    _focusMins = settings.focusMinutes;
    _shortBreakMins = settings.shortBreakMinutes;
    _longBreakMins = settings.longBreakMinutes;
  }

  void _saveSettings() {
    ref.read(focusSettingsNotifierProvider.notifier).updateSettings(
          focusMinutes: _focusMins,
          shortBreakMinutes: _shortBreakMins,
          longBreakMinutes: _longBreakMins,
        );

    final currentMode = ref.read(focusTimerNotifierProvider).mode;
    ref.read(focusTimerNotifierProvider.notifier).selectMode(currentMode);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text(
          'Timer Settings',
          style: TextStyle(
            color: Color(0xFF1B1C4B),
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1B1C4B)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildSettingSlider(
              label: 'Focus Duration',
              value: _focusMins,
              min: 5,
              max: 60,
              unit: 'mins',
              onChanged: (val) => setState(() => _focusMins = val.toInt()),
            ),
            const SizedBox(height: 16),
            _buildSettingSlider(
              label: 'Short Break Duration',
              value: _shortBreakMins,
              min: 1,
              max: 30,
              unit: 'mins',
              onChanged: (val) => setState(() => _shortBreakMins = val.toInt()),
            ),
            const SizedBox(height: 16),
            _buildSettingSlider(
              label: 'Long Break Duration',
              value: _longBreakMins,
              min: 5,
              max: 45,
              unit: 'mins',
              onChanged: (val) => setState(() => _longBreakMins = val.toInt()),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6E1F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSlider({
    required String label,
    required int value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B1C4B),
                ),
              ),
              Text(
                '$value $unit',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFF6E1F),
                ),
              ),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: min,
            max: max,
            activeColor: const Color(0xFFFF6E1F),
            inactiveColor: const Color(0xFFFFEAE0),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
