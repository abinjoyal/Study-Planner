import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_settings_provider.dart';

class AppearancePage extends ConsumerWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(profileSettingsNotifierProvider);
    final notifier = ref.read(profileSettingsNotifierProvider.notifier);
    final isDark = settings.isDarkMode;
    final activeColor = settings.activeColor;

    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFFAF9F6);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: titleColor,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Appearance',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme Mode',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose how StudyPlanner looks on your device',
                style: TextStyle(
                  fontSize: 13.5,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 18),

              Row(
                children: [
                  _buildThemeOption(
                    title: 'Light',
                    icon: Icons.light_mode_rounded,
                    isSelected: !isDark,
                    activeColor: activeColor,
                    cardColor: cardColor,
                    cardBorder: cardBorder,
                    titleColor: titleColor,
                    onTap: () => notifier.toggleDarkMode(false),
                  ),
                  const SizedBox(width: 14),
                  _buildThemeOption(
                    title: 'Dark',
                    icon: Icons.dark_mode_rounded,
                    isSelected: isDark,
                    activeColor: activeColor,
                    cardColor: cardColor,
                    cardBorder: cardBorder,
                    titleColor: titleColor,
                    onTap: () => notifier.toggleDarkMode(true),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Text(
                'Primary Accent Color',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Current active brand accent is ${settings.activeColorName}',
                style: TextStyle(
                  fontSize: 13.5,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: cardBorder,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildColorDot(
                      color: ProfileSettingsState.accentColors[0],
                      name: 'Orange',
                      isSelected: settings.primaryColorIndex == 0,
                      isDark: isDark,
                      onTap: () => notifier.setPrimaryColorIndex(0),
                    ),
                    _buildColorDot(
                      color: ProfileSettingsState.accentColors[1],
                      name: 'Blue',
                      isSelected: settings.primaryColorIndex == 1,
                      isDark: isDark,
                      onTap: () => notifier.setPrimaryColorIndex(1),
                    ),
                    _buildColorDot(
                      color: ProfileSettingsState.accentColors[2],
                      name: 'Purple',
                      isSelected: settings.primaryColorIndex == 2,
                      isDark: isDark,
                      onTap: () => notifier.setPrimaryColorIndex(2),
                    ),
                    _buildColorDot(
                      color: ProfileSettingsState.accentColors[3],
                      name: 'Emerald',
                      isSelected: settings.primaryColorIndex == 3,
                      isDark: isDark,
                      onTap: () => notifier.setPrimaryColorIndex(3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required Color activeColor,
    required Color cardColor,
    required Color cardBorder,
    required Color titleColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 22),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? activeColor : cardBorder,
              width: isSelected ? 2 : 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? activeColor : const Color(0xFF64748B),
                size: 32,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? activeColor : titleColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorDot({
    required Color color,
    required String name,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? (isDark ? Colors.white : const Color(0xFF0F172A))
                    : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: isSelected ? 0.45 : 0.2),
                  blurRadius: isSelected ? 10 : 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 22)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                  : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
